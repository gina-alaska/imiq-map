class ImiqAPI
  include HTTParty
  base_uri 'imiq-api.dev'
  
  def initialize
  end
  
  def sites(search = {}, page = 1, limit = 500, type = :point)
    self.class.get(sites_url(search, page, limit, type))
  end
  
  def sites_uri(search = {}, page = 1, limit = 500, type = :point)
    search.merge!({ page: page, limit: limit, geometry: type }).reject! { |k,v| v.blank? }
    self.class.get_uri("/sites.geojson?#{search.to_param}")
  end
  
  # single site return
  def site(id, format=:json, options= {})
    self.class.get("/site/#{id}.#{format}")
  end
  
  #get list of unique varible values
  def variables_list
    @variables_list ||= self.class.get("/variables/list.json")
  end
  
  #get list of organizations
  def organization_list
    @organization_list ||= self.class.get("/organizations/list.json")
  end
  
  def self.get_uri(path, options = {}, &block)
    request_uri(Net::HTTP::Get, path, options, &block)
  end
  
  private
  
  def self.request_uri(http_method, path, options, &block) #:nodoc:
    options = default_options.merge(options)
    process_cookies(options)
    Request.new(http_method, path, options).uri
  end
end