class PasswordResetWorker
  include Sidekiq::Worker
  
  def perform(id)
    reset = PasswordReset.find(id)
    PasswordResetMailer.send_reset(reset).deliver;
  end
end