class SearchesController < ApplicationController
  def create
    self.current_search = search_params

    case params[:commit]
    when 'export'
      redirect_to new_export_path
    else
      redirect_to search_path
    end
  end

  def show
    @search = current_search
    @imiq_api_url = imiq_api.sites_uri(@search.imiq_api_params).to_s

    respond_to do |format|
      format.js
    end
  end
end
