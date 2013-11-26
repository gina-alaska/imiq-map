class MapsController < ApplicationController
  def index
    # HTTParty.get('http://imiq-api.dev/sites.geojson?geometry=point&limit=5000')
    api = ImiqAPI.new
    
    @sites = api.sites()
  end
end
