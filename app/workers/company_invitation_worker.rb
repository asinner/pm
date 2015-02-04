class CompanyInvitationWorker
  include Sidekiq::Worker
  
  def perform(id)
    invitation = Invitation.find(id)
    InvitationMailer.invite_to_company(invitation).deliver
  end
end