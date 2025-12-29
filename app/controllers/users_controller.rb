class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.recent.page(params[:page]).per(10)
  end

  def subscribe
    @user = User.find(params[:id])

    unless current_user.subscribed_to?(@user)
      current_user.subscriptions.create(subscribed_to: @user)
    end

    redirect_back fallback_location: @user
  end

  def unsubscribe
    @user = User.find(params[:id])
    current_user.subscriptions.find_by(subscribed_to: @user)&.destroy
    redirect_back fallback_location: @user
  end

  def subscriptions
    @subscriptions = current_user.subscribed_to_users.page(params[:page]).per(20)
  end

  def subscribers
    @user = User.find(params[:id])
    @subscribers = @user.subscribers.page(params[:page]).per(20)
  end
end