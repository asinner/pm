class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def index?
    @user.companies.include?(@record.project.company)
  end

  def create?    
    @user.companies.include?(@record.project.company)
  end
  
  def update?
    @user.companies.include?(@record.project.company)
  end

  def taskable?
    @user.companies.include?(@record.project.company)
  end
end
