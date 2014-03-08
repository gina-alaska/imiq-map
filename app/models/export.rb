class Export < ActiveRecord::Base
  serialize :sites
  serialize :variables

  def urls
    @urls = []
    opts = {}
    opts[:startdate] = self.starts_at if self.starts_at?
    opts[:enddate] = self.ends_at if self.ends_at?

    unless self.variables.nil?
      self.variables.each do |var|
        @urls << ImiqAPI.export_uri(self.sites, self.timestep, var, opts)
      end
    end
    
    @urls
  end
end
