class ExportsController < ApplicationController
  before_action :fetch_export

  authorize_resource

  def index
    @exports = current_user.exports.order(created_at: :asc)
  end

  def new
    @export = build_new_export
    if params[:siteid].present?
      @export.search = find_or_create_search({ siteids: params[:siteid] })
    else
      @export.search = current_search
    end

    @sites = @export.search.fetch(1, Export::DEFAULT_SITE_LIMIT)

    respond_to do |format|
      format.html
    end
  end

  def create
    @export = build_new_export(export_params)
    if params[:siteid].present?
      @export.search = find_or_create_search({ siteids: params[:siteid] })
    else
      @export.search = current_search
    end

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

  def build_new_export(export_params = {})
    export = current_user.exports.build(export_params)
    if params[:siteid].present?
      export.search = find_or_create_search({ siteids: params[:siteid] })
    else
      export.search = current_search
    end

    export
  end

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
