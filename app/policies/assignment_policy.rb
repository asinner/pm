class AssignmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def create?
    # Is the assigner authorized for the task? Is the assigner authorized for the user?
    @user.companies.include?(@record.task.project.company) &&
      @record.task.project.company.users.include?(@record.user)
  end
end
