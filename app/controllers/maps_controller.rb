class MapsController < ApplicationController
  def index
    @sites = HTTParty.get('http://imiq-api.dev/sites.geojson?geometry=point&limit=500')
  end
end
