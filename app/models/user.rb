class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :subscriber_subscriptions, class_name: 'Subscription',
           foreign_key: 'subscribed_to_id', dependent: :destroy
  has_many :subscribers, through: :subscriber_subscriptions,
           source: :subscriber

  has_many :subscriptions, foreign_key: 'subscriber_id',
           dependent: :destroy
  has_many :followed_users, through: :subscriptions,
           source: :subscribed_to

  has_many :notifications, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true

  def admin?
    admin
  end

  def subscribed_to?(user)
    # Простая проверка
    Subscription.exists?(subscriber_id: id, subscribed_to_id: user.id)
  end

  def unread_notifications_count
    notifications.where(read: false).count
  end
end
