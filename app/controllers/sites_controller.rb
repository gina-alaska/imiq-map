class SitesController < ApplicationController
  def show
    @site = OpenStruct.new(imiq_api.site(params[:id]))
    
    respond_to do |format|
      format.html { render layout: false }
      format.js
    end
  end
end
