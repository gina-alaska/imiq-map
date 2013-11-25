class MapsController < ApplicationController
  def index
    @sites = HTTParty.get('http://imiq-api.dev/sites.geojson?geometry=point&limit=100')
  end
end
