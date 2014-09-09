class ExportsController < ApplicationController
  respond_to :html, :js, :json
  
  def index
    if session[:exports].present?
      @exports = Export.where(id: session[:exports]).order(created_at: :asc)
    else
      @exports = Export.order(created_at: :asc)
    end
  end
  
  def new
    @export = Export.new
    @sites = [imiq_api.site(params[:siteid], 'json', { verbose: true })]
    respond_with @export
  end

  def create
    @export = Export.new(export_params)
    respond_to do |format|
      if @export.save
        session[:exports] ||= []
        session[:exports] << @export.id
        
        @export.async_build_download()
        format.any { redirect_to @export }
      else
        flash[:danger] = "Unable to create export.\n"
        flash[:danger] += @export.errors.full_messages.join("\n")
        format.html {
          redirect_to root_path          
        }
        format.js
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
