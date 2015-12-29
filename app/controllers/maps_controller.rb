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
        case params[:commit]
        when 'export'
          p = search_params.merge({ verbose: true })
          @sites = imiq_api.sites(p, 1, 1500)
          @export = Export.new

          render '/exports/new'
        when 'show-sites'
          #  redirect_via_turbolinks_to export_sites_path(search_params)
           #imiq_api.sites_uri(search_params, 1, 1500, :point, :pdf)
           self.current_search = search_params
           render '/sites/export'
        when 'export-sites'

        else
          @imiq_api_url = imiq_api.sites_uri(search_params).to_s
        end
      }
    end
  end

end
