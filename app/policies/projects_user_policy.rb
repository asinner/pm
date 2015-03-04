class ProjectsUserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    @user.companies.include?(@record.project.company) && @record.project.company.users.include?(@record.user)
  end
end
