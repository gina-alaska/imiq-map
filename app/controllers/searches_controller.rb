class SearchesController < ApplicationController
  def create
    self.current_search = search_params

    redirect_to search_path
  end

  def show
    @search = current_search
    @imiq_api_url = imiq_api.sites_uri(@search.params).to_s

    respond_to do |format|
      format.html
      format.js
    end
  end
end
