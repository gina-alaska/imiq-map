class MapsController < ApplicationController
  def index
    # HTTParty.get('http://imiq-api.dev/sites.geojson?geometry=point&limit=5000')
  end
  
  def sites
    respond_to do |format|
      format.geojson {
        @sites = imiq_api.sites(params[:page])
    
        render json: @sites
      }      
    end
  end
  
  def search
    respond_to do |format|
      format.js
    end
  end
  
  protected
  
  def search_params
    @search ||= params.permit(:q, :datatype, :samplemedium, :generalcategory, :valuetype, :variablename, :organizationcode, :derived_values)
  end
  helper_method :search_params
  
  def imiq_api
    @api ||= ImiqAPI.new
  end
  helper_method :imiq_api
end
