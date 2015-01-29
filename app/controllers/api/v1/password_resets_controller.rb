class Api::V1::PasswordResetsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    
    token = loop do
      random_token = SecureRandom::uuid
      break random_token unless PasswordReset.exists?(secret: random_token)
    end
    
    reset = PasswordReset.new(user: user, secret: token, expires_at: 1.hour.from_now)
    
    if reset.save
      PasswordResetWorker.perform_async(reset.id)
      render status: 201, json: reset
    else
      render status: 422, json: reset.errors
    end
  end
end
