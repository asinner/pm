class Api::V1::UserPasswordsController < ApplicationController
  before_action :authenticate_user
  
  def update
    return render status: 422, json: 'Old password is invalid' if !current_user.authenticate(params[:old_password])
    
    if current_user.update(password: params[:new_password])
      render status: 200, json: current_user
    else
      render status: 422, json: current_user.errors
    end
  end
end
