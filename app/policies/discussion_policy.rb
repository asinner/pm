class DiscussionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def create?
    @user.companies.include?(@record.project.company)
  end

  def list_comments?
  	belongs_to_user
  end

  def belongs_to_user
		@user.companies.include?(@record.project.company)
  end
end
