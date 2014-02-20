class PagesController < ApplicationController
  def index
    show
  end
  
  def show
    slug = params[:id] || 'home'
    
    render slug
  end
end
