class Api::V1::CompaniesUsersController < ApplicationController
  before_action :authenticate_user
  
  def create
    invitation = Invitation.find_by(key: params[:key])
    return render status: 422, json: {msg: 'Invalid invitation key'} unless invitation
    
    join = CompaniesUser.new(company: invitation.company, user: current_user)
    
    if join.save
      render status: 201, json: join
    else
      render status: 422, json: join.errors
    end
  end
end
