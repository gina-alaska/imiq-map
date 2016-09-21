require 'fileutils'

class DownloadWorker < ActiveJob::Base

  def perform(export)
    @progress = 0

    now = Time.zone.now

    sites = export.search.fetch(1, 200)

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
        status(export, 'Exporting variables')
        run_cmd("wget --content-disposition  \"#{url}\"")
      end

      status(export, 'Building zip file')

      if run_cmd("zip -r #{zip_filename} #{identity}")
        run_cmd("rm #{identity}/* && rmdir #{identity}")
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
    @progress += increment
    @progress = [@progress, 100].min
    m.update_attributes(status: message, progress: (@progress/@total_steps*100).to_i)
  end

  protected

  def run_cmd(cmd, opts = {})
    Rails.logger.info(cmd)
    system(cmd) unless opts[:pretend]
  end
end
