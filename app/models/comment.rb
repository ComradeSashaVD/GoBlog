class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true, length: { minimum: 2, maximum: 500 }

  #after_create :create_notification

  private

  def create_notification
    return if user == post.user # Не уведомляем себя

    Notification.create(
      user: post.user,
      actor: user,
      notifiable: self,
      action: 'commented',
      message: "#{user.username} прокомментировал(а) ваш пост"
    )
  end
end
