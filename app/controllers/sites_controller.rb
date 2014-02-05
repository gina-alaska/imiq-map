class SitesController < ApplicationController
  def show
    @download_urls = imiq_api.site_downloads(params[:id])
    
    respond_to do |format|
      format.js
    end
  end
end
