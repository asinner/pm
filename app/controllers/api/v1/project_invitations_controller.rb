class Api::V1::ProjectInvitationsController < ApplicationController
  before_action :authenticate_user
  
  def create
    project = Project.find(params[:project_id])
    user = User.find_by(email: params[:recipient])
    
    invitation = Invitation.new(invitable: project, recipient: params[:recipient])
    authorize invitation
    
    return render status: 402, json: {msg: 'Please renew your subscription'} if project.company.inactive?
    return render status: 422, json: {msg: 'User is already on this project'} if user && project.team.includes?(user)
    invitation.key = TokenService.create_for(Invitation, :key)
    
    if invitation.save
      ProjectInvitationWorker.perform_async(invitation.id)
      render status: 201, json: invitation
    else
      render status: 422, json: invitation.errors
    end
  end
end
