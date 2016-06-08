class ExportsController < ApplicationController
  before_action :fetch_export

  authorize_resource

  def index
    if session[:exports].present?
      @exports = Export.where(id: session[:exports]).order(created_at: :asc)
    else
      @exports = Export.order(created_at: :asc)
    end
  end

  def new
    @export = Export.new
    if params[:siteid].present?
      self.export_search = find_or_create_search({ siteids: params[:siteid] })
    else
      self.export_search = current_search
    end

    @sites = export_search.fetch(1, 200)

    respond_to do |format|
      format.html
    end
  end

  def create
    @export = current_user.exports.build(export_params)
    @export.sites = export_search.to_global_id.to_s

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
    @export.async_build_download()

    render 'show'
  end

  def download
    send_file @export.download.file
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  protected

  def fetch_export
    @export = Export.find(params[:id]) if params[:id].present?
  end

  def export_search
    @export_search ||= GlobalID::Locator.locate session[:export_search_gid]
  end

  def export_search=(search)
    session[:export_search_gid] = search.to_global_id.to_s

    search
  end

  def export_params
    eparms = params.require(:export).permit({ variables: [] },
      :starts_at, :ends_at, :timestep, :email)

    eparms
  end
end
