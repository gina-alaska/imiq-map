class SitesController < ApplicationController
  def show
    @site = OpenStruct.new(imiq_api.site(params[:id]))
    @content = imiq_api.site(params[:id], 'html')
    
    respond_to do |format|
      format.html { render layout: false }
      format.js
    end
  end
end
