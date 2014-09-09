require 'fileutils'

class DownloadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(id)
    export = Export.find(id)
    now = Time.zone.now

    # number of urls + 2 extra steps
    fetch_api_uris = export.site_list_urls + export.urls
    total = (fetch_api_uris.count + 3).to_f
    prog = 0
    
    puts "Total steps: #{total}"
    
    status(export, 'Downloading data', (prog/total*100).to_i)
    
    identity = "imiq_export_#{now.strftime('%Y%m%d_%H%M%S')}"
    save_directory = Rails.root.join("exports/#{now.year}/#{now.month}/#{now.day}/#{now.to_i}#{id}").to_s
    zip_filename = "#{identity}_#{id}.zip"
    
    FileUtils.mkdir_p(save_directory)
    
    Dir.chdir(save_directory) do
      FileUtils.mkdir_p(identity)
      Dir.chdir(identity) do
        run_cmd("cp -r #{Rails.root.join('export_template/*')} .")
        
        prog += 1
        status(export, 'Copying template', (prog/total*100).to_i)          
      
      
        fetch_api_uris.each_with_index do |url,index|
          # run_cmd("curl -O -J -L \"#{url}\"")
          run_cmd("wget --content-disposition  \"#{url}\"")
          
          prog += 1
          status(export, 'Downloading data', (prog/total*100).to_i)    
        end
      end
      
      prog += 1
      status(export, 'Building zip file', (prog/total*100).to_i)    

      if run_cmd("zip -r #{zip_filename} #{identity}")
        run_cmd("rm #{identity}/* && rmdir #{identity}")
      end
      
      prog += 1      
      status(export, 'Building zip file', (prog/total*100).to_i)    
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
  
  def status(m, message, progress)
    m.update_attributes(status: message, progress: progress)    
  end
  
  protected
  
  def run_cmd(cmd, opts = {})
    puts cmd
    system(cmd) unless opts[:pretend]
  end
end