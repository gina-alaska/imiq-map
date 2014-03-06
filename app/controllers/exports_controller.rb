class ExportsController < ApplicationController
  respond_to :html, :js
  def new
    @export = Export.new
    
    respond_with @export
  end
  
  def create
    
  end
end
