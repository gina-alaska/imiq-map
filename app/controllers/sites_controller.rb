class SitesController < ApplicationController
  def index
    @sites = SitesPager.new(imiq_api.sites(search_params, params[:page] || 1, 50))

    respond_to do |format|
      format.html
    end
  end

  def export
    respond_to do |format|
      format.js
    end
  end

  def show
    @site = OpenStruct.new(imiq_api.site(params[:id]))

    respond_to do |format|
      format.html { render layout: false }
      format.js
    end
  end

end
