class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def update?
    @user.companies.include?(@record.company)
  end
end
