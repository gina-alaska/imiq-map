class MapsController < ApplicationController
  def index
    # HTTParty.get('http://imiq-api.dev/sites.geojson?geometry=point&limit=5000')
  end
  
  def sites
    respond_to do |format|
      format.geojson {
        api = ImiqAPI.new    
        @sites = api.sites(params[:page])
    
        render json: @sites
      }      
    end
  end
end
