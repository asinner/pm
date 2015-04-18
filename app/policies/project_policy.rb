class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    @user.companies.include?(@record[0].company)
  end
  
  def show?
    update?
  end
  
  def update?
    @user.companies.include?(@record.company)
  end

  def taskable?
    @user.companies.include?(@record.company)
  end

  def list_discussions?
    belongs_to_user
  end

  def belongs_to_user
    @user.companies.include?(@record.company)
  end
end
