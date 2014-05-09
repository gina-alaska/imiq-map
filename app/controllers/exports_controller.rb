class ExportsController < ApplicationController
  respond_to :html, :js, :json
  def new
    @export = Export.new
    @sites = [imiq_api.site(params[:siteid], 'json', { verbose: true })]
    respond_with @export
  end

  def create
    @export = Export.new(export_params)
    respond_to do |format|
      if @export.save and @export.urls.count > 0
        @export.async_build_download()
        format.any { redirect_to @export }
      else
        flash[:danger] = "Unable to export using the given options"
        redirect_to root_path
      end
    end
  end
  
  def retry
    @export = Export.find(params[:id])
    @export.async_build_download()
    
    render 'show'
  end
  
  def download
    @export = Export.find(params[:id])
    
    send_file @export.download.file
  end

  def show
    @export = Export.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  protected

  def export_params
    eparms = params.require(:export).permit({ sites: [] }, { variables: [] },
      :starts_at, :ends_at, :timestep, :email)

    
    eparms
  end
end
