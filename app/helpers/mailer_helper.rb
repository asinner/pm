module MailerHelper
  def filter_to(address)
    return address if Rails.env == "production"
    SES.identities.first.identity
  end
  
  def app_url
    options = Rails.configuration.action_mailer.default_url_options
    protocol = options[:protocol]
    host = options[:host]
    "#{protocol}://#{host}"
  end
end