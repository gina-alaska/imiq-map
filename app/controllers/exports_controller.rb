class ExportsController < ApplicationController
  respond_to :html, :js
  def new
    @export = Export.new
    @sites = [imiq_api.site(params[:siteid], 'json', { verbose: true })]
    respond_with @export
  end

  def create
    @export = Export.new(export_params)
    respond_to do |format|
      if @export.save and @export.urls.count > 0
        if Rails.env.production?
        
          format.html {        
            flash[:info] = "Exports are currently disabled"
            redirect_to root_path
          }
        else
          @export.async_build_download()
          format.any { redirect_to @export }
        end
      else
        flash[:danger] = "Unable to export using the given options"
        redirect_to root_path
      end
    end
  end
  
  def retry
    @export = Export.find(params[:id])
    @export.async_build_download()
    
    redirect_to @export
  end
  
  def download
    @export = Export.find(params[:id])
    
    send_file @export.download.file
  end

  def show
    @export = Export.find(params[:id])
    respond_with(@export)
  end

  protected

  def export_params
    eparms = params.require(:export).permit({ sites: [] }, { variables: [] },
      :starts_at, :ends_at, :timestep, :email)

    eparms
  end
end
