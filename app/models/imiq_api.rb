class ImiqAPI
  include HTTParty

  base_uri (Rails.env == 'development' ? "http://imiq-api.192.168.222.226.xip.io" : 'http://imiq-api.gina.alaska.edu')

  def initialize
  end

  def sites(search = {}, page = 1, limit = 500, type = :point)
    self.class.get(sites_uri(search, page, limit, type, 'json'))
  end

  def sites_uri(search = {}, page = 1, limit = 500, type = :point, format = 'geojson')
    search.merge!({ page: page, limit: limit, geometry: type }).reject! { |k,v| v.blank? }
    self.class.get_uri("/sites.#{format}?#{search.to_param}").to_s
  end

  # single site return
  def site(id, format=:json, options= {})
    self.class.get("/sites/#{id}.#{format}?#{options.to_param}")
  end

  def site_downloads(id, format=:json, options = {})
    self.class.get("/sites/#{id}/downloads.#{format}?#{options.to_param}")
  end

  #get list of unique varible values
  def self.site_list_uri(siteids, opts={}, format = 'txt')
    get_uri("/sites/list.#{format}?siteids=#{siteids.join(',')}&#{opts.to_param}")
  end


  #get list of unique varible values
  def variables_list
    @variables_list ||= self.class.get("/variables/list.json")
  end

  #get list of networks
  def network_list
    @network_list ||= self.class.get("/networks/list.json")
  end

  #get list of organizations
  def organization_list
    @organization_list ||= self.class.get("/organizations/list.json")
  end

  def self.export_uri(siteids, variable, opts = {}, format = 'csv')
    get_uri("/export/#{variable}.#{format}?siteids=#{siteids.join(',')}&#{opts.to_param}")
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
