class ImiqAPI
  include HTTParty
  base_uri 'imiq-api.dev'
  
  def initialize
  end
  
  def sites(page = 1, limit = 3000, type = :point, options={})
    self.class.get("/sites.geojson?geometry=#{type}&page=#{page}&limit=#{limit}", options)
  end
  
  def site(id, format=:json, options= {})
    self.class.get("/site/#{id}.#{format}")
  end
end