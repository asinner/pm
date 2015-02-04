class Api::V1::InvitationsController < ApplicationController
  before_action :authenticate_user
  
  def create
    company = Company.find(params[:company_id])
    authorize company
    
    invitations = []
    rejects = []
    
    params[:emails].each do |email|
      inv = company.invitations.build(
        recipient: email,
        key: SecureRandom::uuid
      )
      
      if inv.save
        invitations << inv
        CompanyInvitationWorker.perform_async(inv.id)
      else
        rejects << inv
      end
    end
    
    if rejects.empty?
      render status: 201, json: invitations
    else
      render status: 422, json: rejects
    end
  end
end
