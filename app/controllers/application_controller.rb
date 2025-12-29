class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :set_notifications

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_notifications
    return unless current_user
    @unread_notifications_count = current_user.unread_notifications_count
    @notifications = current_user.notifications.recent.limit(5)
  end

  def user_not_authorized
    flash[:alert] = "У вас нет прав для этого действия."
    redirect_to(request.referrer || root_path)
  end
end
