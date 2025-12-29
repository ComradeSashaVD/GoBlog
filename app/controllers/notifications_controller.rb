class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.recent.page(params[:page]).per(20)
    current_user.notifications.unread.update_all(read: true)
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!
    redirect_back fallback_location: notifications_path
  end
end