class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    if user.admin?
      true
    else
      user.role == 'user' && record.user_id == user.id
    end
  end
end