class Api::V1::UserPasswordsController < ApplicationController
  before_action :authenticate_user, only: %w(update)
  
  def new
  end
  
  def create
    reset = PasswordReset.find_by(secret: params[:secret])
    return render status: 404, json: 'Could not find password reset with the supplied secret' if reset.nil?
    return render status: 422, json: 'Password reset secret has expired' if reset.expired?
    user = reset.user
    
    if user.update(password: params[:password])
      render status: 200, json: user
    else
      render status: 422, json: user.errors
    end
  end
  
  def update
    return render status: 422, json: 'Old password is invalid' if !current_user.authenticate(params[:old_password])
    
    if current_user.update(password: params[:new_password])
      render status: 200, json: current_user
    else
      render status: 422, json: current_user.errors
    end
  end
end
