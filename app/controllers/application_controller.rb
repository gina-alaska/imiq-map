class ApplicationController < ActionController::Base
  include GinaAuthentication::AppHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :allow_iframe!

  rescue_from CanCan::AccessDenied do |_exception|
    if signed_in?
      flash[:error] = 'You do not have permission to view this page'
      redirect_to root_url
    else
      session[:redirect_back_to] = request.original_url
      redirect_to page_path('login_required')
    end
  end

  protected

  def allow_iframe!
    response.headers.except! 'X-Frame-Options'
  end

  def imiq_api
    @api ||= ImiqAPI.new
  end
  helper_method :imiq_api

  def search_params
    params.permit(:q, :datatype, :samplemedium, :generalcategory,
      :valuetype, :variablename, :networkcode, :organizationcode, :derived_values,
      :time_step, bounds: [:sw_lat, :sw_lng, :ne_lat, :ne_lng])
  end
  helper_method :search_params

  def current_search
    @current_search ||= Search.where(id: session[:current_search_id]).first
    @current_search ||= find_or_create_search({})
  end
  helper_method :current_search

  def current_search=(search)
    @current_search = find_or_create_search(search)
    session[:current_search_id] = @current_search.id

    @current_search
  end

  def find_or_create_search(search = {})
    Search.first_or_create_with_search(search)
  end
end
