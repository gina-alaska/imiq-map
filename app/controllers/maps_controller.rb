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
        if params[:commit] == 'Export'
          p = search_params.merge({ verbose: true })
          @sites = imiq_api.sites(p, 1, 1500)
          @export = Export.new

          render '/exports/new'
        else
          @imiq_api_url = imiq_api.sites_uri(search_params).to_s
        end
      }
    end
  end

  protected

  def search_params
    @search ||= params.permit(:q, :datatype, :samplemedium, :generalcategory,
      :valuetype, :variablename, :organizationcode, :derived_values, :bounds,
      :time_step)
  end
  helper_method :search_params
end
