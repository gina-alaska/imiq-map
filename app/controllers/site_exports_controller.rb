class SiteExportsController < ApplicationController
  before_action :fetch_site_export, only: [:show, :retry]

  authorize_resource

  def create
    @site_export = current_user.site_exports.build(search: current_search)

    respond_to do |format|
      if @site_export.save
        @site_export.queue_export
        flash[:notice] = 'Site export queued'
        format.html { redirect_to @site_export }
      else
        flash[:error] = 'Unable to create export job'
        format.html { redirect_to sites_path }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.csv { send_file @site_export.search.export_filename }
    end
  end

  def retry
    @site_export.queue_export
    redirect_to @site_export
  end

  protected

  def fetch_site_export
    @site_export = SiteExport.find(params[:id])
  end
end
