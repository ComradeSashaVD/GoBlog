class PostPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (record.user == user || user.admin?)
  end

  def destroy?
    user.present? && (record.user == user || user.admin?)
  end

  def vote?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end