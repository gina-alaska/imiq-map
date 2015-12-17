class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :allow_iframe!

  protected

  def allow_iframe!
    response.headers.except! 'X-Frame-Options'
  end

  def imiq_api
    @api ||= ImiqAPI.new
  end
  helper_method :imiq_api

  protected

  def search_params
    @search ||= params.permit(:q, :datatype, :samplemedium, :generalcategory,
      :valuetype, :variablename, :networkcode, :organizationcode, :derived_values,
      :time_step, bounds: [:sw_lat, :sw_lng, :ne_lat, :ne_lng])
  end
  helper_method :search_params
end
