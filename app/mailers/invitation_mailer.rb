class InvitationMailer < ActionMailer::Base
  include MailerHelper
  default from: "andrewsinner@gmail.com"
  
  def invite_to_company(invitation)
    @invitation = invitation
    @company = @invitation.company
    
    email = filter_to(@invitation.recipient)
    mail(to: email, subject: "#{@invitation.company.name} has invited you to join their team")
  end
end
