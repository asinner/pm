class ProjectInvitationWorker
  include Sidekiq::Worker
  
  def perform(id)
    invitation = Invitation.find(id)
    ProjectInvitationMailer.send_invitation(invitation)
  end
end