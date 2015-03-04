class ProjectInvitationMailer < ActionMailer::Base
  include MailerHelper
  
  default from: "andrewsinner@gmail.com"
  
  def send_invite(invitation)
    @invitation = invitation
    @project = invitation.invitable
    @sender = invitation.sender
    mail(to: filter_to(invitation.recipient), subject: "You've been invited to join the team");
  end
end
