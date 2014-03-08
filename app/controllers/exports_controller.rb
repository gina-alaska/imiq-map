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
      format.html {
        if @export.save
          redirect_to @export.urls.first.to_s
        else
          render :edit
        end
      }
    end
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
