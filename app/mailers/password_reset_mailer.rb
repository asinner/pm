class PasswordResetMailer < ActionMailer::Base
  include MailerHelper
  
  default from: "andrewsinner@gmail.com"
  
  def send_reset(reset)
    @app_url = app_url()
    @reset = reset
    mail(to: filter_to(reset.user.email), subject: "Password reset")
  end
end
