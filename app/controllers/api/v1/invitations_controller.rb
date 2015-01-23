class Api::V1::InvitationsController < ApplicationController
  def create
    invitations = []
    rejects = []
    
    params[:emails].each do |email|
      inv = current_user.company.invitations.build(
        recipient: email,
        key: SecureRandom::uuid
      )
      inv.save ? invitations << inv : rejects << inv
    end
    
    if rejects.empty?
      render status: 201, json: invitations
    else
      render status: 422, json: rejects
    end
  end
end
