require 'fileutils'
require 'uri'
require 'net/http'

class DownloadWorker < ActiveJob::Base

  def perform(export)
    @progress = 0

    now = Time.zone.now

    sites = export.search.fetch(1, Export::DEFAULT_SITE_LIMIT)

    site_ids = sites.collect(:siteid).uniq.compact
    raise "No sites found" if site_ids.empty?

    variable_urls = export.variable_urls(site_ids)

    # number of urls + 2 extra steps
    @total_steps = (variable_urls.count + 3).to_f

    Rails.logger.info "Total steps: #{@total_steps}"

    status(export, 'Starting export', 0)

    identity = "imiq_export_#{now.strftime('%Y%m%d_%H%M%S')}"
    save_directory = Rails.root.join("exports/#{now.year}/#{now.month}/#{now.day}/#{now.to_i}#{export.id}").to_s
    zip_filename = "#{identity}_#{export.id}.zip"

    workspace = ::File.join(save_directory, identity)

    FileUtils.mkdir_p(workspace)
    Dir.chdir(workspace) do
      status(export, 'Copying template')
      run_cmd("cp -r #{Rails.root.join('export_template/*')} .")

      variable_urls.each do |url|
        page = 1
        header = true

        default_csv_filename = File.basename(URI(url).path)
        status(export, "Exporting #{default_csv_filename}")

        response = fetch_content(url, header, page)
        while response.body.length > 0
          File.open(get_filename(response['Content-Disposition']) || default_csv_filename, 'a') do |fp|
            fp << response.body
          end

          header = false
          page += 1
          response = fetch_content(url, header, page)
        end
      end

      status(export, 'Building zip file')
    end

    Dir.chdir(save_directory) do
      if run_cmd("zip -r #{::File.join(save_directory, zip_filename)} #{identity}")
        run_cmd("rm #{workspace}/* && rmdir #{workspace}")
      end
    end

    if export.download.nil?
      export.create_download(file: File.join(save_directory, zip_filename))
    else
      export.download.update_attribute(:file, File.join(save_directory, zip_filename))
    end

    unless export.email.blank?
      DownloadMailer.download_ready_email(export).deliver
    end

    status(export, 'Complete', 100)
  rescue => e
    export.update_attributes({ status: 'Error', message: e.message, progress: 0 })
    raise e
  end

  def status(m, message, increment = 1)
    @steps ||= 0
    @steps += increment
    progress = [@steps/@total_steps*100, 100].min
    m.update_attributes(status: message, progress: progress.to_i)
  end

  protected

  def get_filename(disposition)
    disposition.match(/filename=(\"?)(.+)\1/)[2]
  end

  def update_params(url, header, page)
    uri = URI(url)

    params = URI.decode_www_form(uri.query).to_h
    params['header'] = header
    params['page'] = page

    uri.query = URI.encode_www_form(params)

    uri
  end

  def fetch_content(url, header, page)
    uri = URI(url)
    params = URI.decode_www_form(uri.query).to_h
    params['header'] = header
    params['page'] = page
    uri.query = URI.encode_www_form(params)
    Rails.logger.info "Fetching: #{uri.to_s}"
    Net::HTTP.get_response(uri)
  end

  def run_cmd(cmd, opts = {})
    Rails.logger.info(cmd)
    system(cmd) unless opts[:pretend]
  end
end
