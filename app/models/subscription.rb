class Subscription < ApplicationRecord
  # Простые ассоциации
  belongs_to :subscriber, class_name: 'User'
  belongs_to :subscribed_to, class_name: 'User'

  # Валидации
  validates :subscriber_id, uniqueness: { scope: :subscribed_to_id }
  validate :cannot_subscribe_to_self

  private

  def cannot_subscribe_to_self
    if subscriber_id == subscribed_to_id
      errors.add(:subscriber, "нельзя подписаться на себя")
    end
  end
end