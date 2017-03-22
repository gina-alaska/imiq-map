class ReportsController < ApplicationController
  authorize_resource :class => false

  def downloads
    if params["/exports/report"]
      @start_date = params["/exports/report"]["starts_at"]
      @end_date = params["/exports/report"]["ends_at"]

      exports = Export.where(created_at: @start_date...@end_date).joins(:user).where(users: {admin: false})
      @export_count = exports.count
      @user_names = exports.map(&:user).map(&:name).uniq
      @new_user_count = User.where(created_at: @start_date...@end_date).where(users: {admin: false}).count
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end
end
