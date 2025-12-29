class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User'
  belongs_to :subscribed_to, class_name: 'User'

  validates :subscriber_id, uniqueness: { scope: :subscribed_to_id }
  validate :cannot_subscribe_to_self

  private

  def cannot_subscribe_to_self
    errors.add(:subscriber, "нельзя подписаться на себя") if subscriber == subscribed_to
  end
end
