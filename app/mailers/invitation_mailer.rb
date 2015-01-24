class InvitationMailer < ActionMailer::Base
  default from: "andrewsinner@gmail.com"
  
  def invite_to_company(invitation)
    @invitation = invitation
    @company = @invitation.company
    
    email = filter_to(@invitation.recipient)
    mail(to: email, subject: "#{@invitation.company.name} has invited you to join their team")
  end
  
  def filter_to(address)
    return address if Rails.env == "production"
    SES.identities.first.identity
  end
end
