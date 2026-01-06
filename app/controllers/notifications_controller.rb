# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications
                                 .includes(:actor, :notifiable)
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(20)
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.update(read: true)
    redirect_back fallback_location: notifications_path
  end

  # Добавьте этот метод если нужно
  def mark_all_as_read
    current_user.notifications.unread.update_all(read: true)
    redirect_back fallback_location: notifications_path
  end
end