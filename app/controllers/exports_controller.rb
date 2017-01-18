class ExportsController < ApplicationController
  before_action :fetch_export, except: :report

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

    respond_to do |format|
      if @export.save
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

  def report
    if params["/exports/report"]
      @start_date = params["/exports/report"]["starts_at"]
      @end_date = params["/exports/report"]["ends_at"]

      exports = Export.where(created_at: @start_date...@end_date).joins(:user).where(users: {admin: false})
      @export_count = exports.count
      @user_names = exports.map(&:user).map(&:name).uniq
      @new_user_count = User.where(created_at: @start_date...@end_date).count
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  protected

  def build_new_export(export_params = {})
    current_user.exports.build(export_params)
  end

  def fetch_export
    @export = Export.find(params[:id]) if params[:id].present?
  end

  def export_params
    eparms = params.require(:export).permit(:search_id, :starts_at, :ends_at, :timestep, :email, variables: [])

    eparms
  end
end
