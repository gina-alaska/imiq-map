require 'fileutils'

class DownloadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(id)
    export = Export.find(id)
    now = Time.zone.now

    # number of urls + 2 extra steps
    fetch_api_uris = [export.site_list_url] + export.urls
    total = (fetch_api_uris.count + 3).to_f
    prog = 0
    
    puts "Total steps: #{total}"
    
    status(export, 'Downloading data', (prog/total*100).to_i)
    
    save_directory = Rails.root.join("exports/#{now.year}/#{now.month}/#{now.day}/#{now.to_i}#{id}").to_s
    zip_filename = "imiq_export_#{now.strftime('%Y%m%d_%H%M%S')}_#{id}.zip"
    
    FileUtils.mkdir_p(save_directory)
    
    Dir.chdir(save_directory) do
      `cp -r #{Rails.root.join('export_template/*')} .`
      prog += 1
      status(export, 'Copying template', (prog/total*100).to_i)          
      
      
      fetch_api_uris.each_with_index do |url,index|
        `curl -O -J -L "#{url}"`
        prog += 1
        status(export, 'Downloading data', (prog/total*100).to_i)    
      end

      prog += 1
      status(export, 'Building zip file', (prog/total*100).to_i)    

      `zip #{zip_filename} * && rm *.csv && rm *.txt`
      
      prog += 1      
      status(export, 'Building zip file', (prog/total*100).to_i)    
    end
    
    if export.download.nil?
      export.create_download(file: File.join(save_directory, zip_filename))
    else
      export.download.update_attribute(:file, File.join(save_directory, zip_filename))
    end
    
    status(export, 'Complete', 100)
  rescue => e
    export.update_attributes({ status: 'Error', message: e.message, progress: 0 })    
    raise e
  end
  
  def status(m, message, progress)
    m.update_attributes(status: message, progress: progress)    
  end
end