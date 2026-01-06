class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.recent.page(params[:page]).per(10)
  end

  def subscribe
    @user = User.find(params[:id])

    if current_user == @user
      redirect_back fallback_location: @user, alert: 'Нельзя подписаться на себя'
      return
    end

    unless current_user.subscribed_to?(@user)
      Subscription.create(subscriber_id: current_user.id, subscribed_to_id: @user.id)
    end

    redirect_back fallback_location: @user, notice: 'Подписка оформлена'
  end

  def unsubscribe
    @user = User.find(params[:id])
    subscription = Subscription.find_by(
      subscriber_id: current_user.id,
      subscribed_to_id: @user.id
    )

    if subscription
      subscription.destroy
      redirect_back fallback_location: @user, notice: 'Подписка отменена'
    else
      redirect_back fallback_location: @user, alert: 'Вы не подписаны на этого пользователя'
    end
  end

  def subscriptions
    @subscriptions = current_user.subscribed_to_users.page(params[:page]).per(20)
  end

  def subscribers
    @user = User.find(params[:id])
    @subscribers = @user.subscribers.page(params[:page]).per(20)
  end
end