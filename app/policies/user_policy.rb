class UserPolicy < ApplicationPolicy
  def index?
    user&.admin? # Verifica se user existe antes de chamar admin?
  end

  def show?
    user&.admin? || user&.id == record.id
  end

  def create?
    user.present?
  end

  def update?
    user&.admin? || (user&.role == 'user' && user&.id == record.id)
  end

  def destroy?
    user&.admin?
  end

  def permitted_attributes
    [:name, :email, :password, :role, :admin]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user # Se user for nil, retorna vazio
      user.admin? ? scope.all : scope.where(id: user.id)
    end
  end
end
