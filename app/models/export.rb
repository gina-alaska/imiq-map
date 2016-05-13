class Export < ActiveRecord::Base
  serialize :variables, JSON

  belongs_to :user
  has_one :download

  validate :end_date_after_start_date, :at_least_one_variable

  def sites
    GlobalID::Locator.locate super
  end

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

  def variable_urls(siteids)
    urls = []
    opts = {}
    opts[:startdate] = self.starts_at if self.starts_at?
    opts[:enddate] = self.ends_at if self.ends_at?

    unless self.variables.nil?
      self.variables.each do |var|
        urls << ImiqAPI.export_uri(siteids, var, opts)
      end
    end

    urls
  end

  # def urls
  #   @urls = []
  #   opts = {}
  #   opts[:startdate] = self.starts_at if self.starts_at?
  #   opts[:enddate] = self.ends_at if self.ends_at?
  #
  #   unless self.variables.nil?
  #     self.variables.each do |var|
  #       @urls << ImiqAPI.export_uri(self.sites, var, opts)
  #     end
  #   end
  #
  #   @urls
  # end

  # def site_list_urls
  #   [
  #     ImiqAPI.site_list_uri(self.sites, {}, 'pdf')
  #   ]
  # end

  def async_build_download
    DownloadWorker.perform_later self
    update_attributes(status: 'Queued', progress: 0)
  end
end
