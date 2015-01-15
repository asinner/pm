class Api::V1::UsersController < ApplicationController
  wrap_parameters :user, include: User.attribute_names + [:password]
  
  def create
    user = User.new(user_params)
    
    if user.save
      render status: 201, json: user
    else
      render status: 422, json: user.errors
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
