class Search < ActiveRecord::Base
  serialize :params, JSON

  def self.params_dump(data)
    JSON.dump(data.to_hash)
  end

  def fetch(page = 1, limit = 50)
    imiq_api = ImiqAPI.new

    SitesPager.new(imiq_api.sites(params, page, limit))
  end
end
