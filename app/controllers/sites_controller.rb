class SitesController < ApplicationController
  def show
    @site = imiq_api.site(params[:id], :json, { verbose: true })
    @sitedervars = @site['derived_variables']
    respond_to do |format|
      format.js
    end
  end
end
