class ExportsController < ApplicationController
  respond_to :html, :js
  def new
    @export = Export.new
    @sites = [imiq_api.site(params[:siteid], 'json', { verbose: true })]
    respond_with @export
  end

  def create

  end
end
