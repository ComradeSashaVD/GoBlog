class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  has_one_attached :image

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :content, presence: true, length: { minimum: 10 }

  scope :recent, -> { order(created_at: :desc) }

  def likes_count
    likes.where(value: 1).count
  end

  def dislikes_count
    likes.where(value: -1).count
  end

  def liked_by?(user)
    likes.exists?(user: user, value: 1)
  end

  def disliked_by?(user)
    likes.exists?(user: user, value: -1)
  end

  def user_reaction(user)
    like = likes.find_by(user: user)
    like&.value
  end

  #after_create :notify_subscribers

  private

  def notify_subscribers
    user.subscribers.each do |subscriber|
      Notification.create(
        user: subscriber,
        actor: user,
        notifiable: self,
        action: 'new_post',
        message: "#{user.username} опубликовал(а) новый пост"
      )
    end
  end
end
