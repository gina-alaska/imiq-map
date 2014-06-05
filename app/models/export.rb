class Export < ActiveRecord::Base
  serialize :sites
  serialize :variables

  has_one :download

  validate :end_date_after_start_date, :at_least_one_variable
  
  def at_least_one_variable
    if self.variables.nil? or self.variables.size == 0
      errors.add(:base, 'Must select at least one parameter.')
    end
  end
  
  def end_date_after_start_date
    if self.starts_at? and self.ends_at?
      if self.ends_at < self.starts_at
        errors.add(:base, 'End date must be after the start date.')
      end
    end
  end

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
