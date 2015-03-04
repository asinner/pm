class Api::V1::CompanyInvitationsController < ApplicationController
  before_action :authenticate_user
  
  def create
    company = Company.find(params[:company_id])
    user = User.find_by(email: params[:recipient])
    invitation = Invitation.new(invitable: company, recipient: params[:recipient])
    authorize invitation
    
    return render status: 402, json: {msg: 'Please renew your subscription'} if company.inactive?
    return render status: 422, json: {msg: 'User has already joined this company'} if user && company.users.includes?(user)

    invitation.key = TokenService.create_for(Invitation, :key)
    
    if invitation.save
      render status: 201, json: invitation
    else
      render status: 422, json: invitation.errors
    end
  end
end
