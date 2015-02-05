class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def show?
    update?
  end
  
  def update?
    @user.companies.include?(@record.company)
  end
end
