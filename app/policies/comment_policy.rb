class CommentPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    user.present? && (record.user == user || user.admin? || record.post.user == user)
  end
end