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
      format.js {
        if params[:commit] == 'Tabular View'
          p = search_params.merge({ verbose: true })
          @sites = imiq_api.sites(p, params[:page], params[:limit])
          
          render 'table_results'
        else
          @imiq_api_url = imiq_api.sites_uri(search_params).to_s    
        end
      }
    end
  end
  
  protected
  
  def search_params
    @search ||= params.permit(:q, :datatype, :samplemedium, :generalcategory, :valuetype, :variablename, :organizationcode, :derived_values, :bounds)
  end
  helper_method :search_params
end
