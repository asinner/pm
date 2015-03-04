class InvitationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
  
  def create?    
    case @record.invitable_type
    when "Company"      
      @user.companies.include?(@record.invitable)
    when "Project"
      @user.companies.include?(@record.invitable.company)
    end
  end
end
