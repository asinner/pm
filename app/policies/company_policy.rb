class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def create?
    @user.companies.include?(@record)
  end
  
  def update?
    create?
  end
end
