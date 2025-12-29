class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :user_id, uniqueness: {
    scope: [:likeable_id, :likeable_type],
    message: "может голосовать только один раз"
  }
  validates :value, inclusion: { in: [-1, 1] }

  after_create :create_notification
  after_destroy :destroy_related_notification

  private

  def create_notification
    return if user == likeable.user

    action = value == 1 ? 'liked' : 'disliked'
    message = value == 1 ? 'лайкнул(а)' : 'дизлайкнул(а)'

    Notification.create(
      user: likeable.user,
      actor: user,
      notifiable: likeable,
      action: action,
      message: "#{user.username} #{message} ваш #{likeable.class.name.downcase}"
    )
  end

  def destroy_related_notification
    Notification.where(
      user: likeable.user,
      actor: user,
      notifiable: likeable,
      action: ['liked', 'disliked']
    ).destroy_all
  end
end
