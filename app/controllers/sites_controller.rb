class SitesController < ApplicationController
  def index
    @sites = fetch_sites(params[:page])

    respond_to do |format|
      format.html
      format.js
      format.csv
    end
  end

  def show
    @site = OpenStruct.new(imiq_api.site(params[:id]))

    respond_to do |format|
      format.html { render layout: false }
      format.js
    end
  end

  protected

  def fetch_sites(page = 1)
    SitesPager.new(imiq_api.sites(current_search.params, page || 1, 50))
  end
  helper_method :fetch_sites

end
