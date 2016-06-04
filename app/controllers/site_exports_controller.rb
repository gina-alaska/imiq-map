class SiteExportsController < ApplicationController
  before_action :fetch_site_export, only: [:show]

  authorize_resource

  def create
    @site_export = current_user.site_exports.build(search: current_search)

    respond_to do |format|
      if @site_export.save
        flash[:notice] = 'Site export queued'
        format.html { redirect_to @site_export }
      else
        flash[:error] = 'Unable to create export job'
        format.html { redirect_to sites_path }
      end
    end
  end

  def show
  end

  protected

  def fetch_site_export
    @site_export = SiteExport.find(params[:id])
  end
end
