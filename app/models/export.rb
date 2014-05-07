class Export < ActiveRecord::Base
  serialize :sites
  serialize :variables

  has_one :download

  def urls
    @urls = []
    opts = {}
    opts[:startdate] = self.starts_at if self.starts_at?
    opts[:enddate] = self.ends_at if self.ends_at?

    unless self.variables.nil?
      self.variables.each do |var|
        @urls << ImiqAPI.export_uri(self.sites, var, opts)
      end
    end
    
    @urls
  end
  
  def site_list_url
    ImiqAPI.site_list_uri(self.sites)
  end
  
  def async_build_download
    DownloadWorker.perform_async(id)
    update_attributes(status: 'Queued', progress: 0)
  end
end
