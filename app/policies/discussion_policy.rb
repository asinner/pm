class DiscussionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def create?
    @user.companies.include?(@record.project.company)
  end
end
