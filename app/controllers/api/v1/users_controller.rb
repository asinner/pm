class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  wrap_parameters :user, include: User.attribute_names + [:password]
  
  def create
    user = User.new(user_params)
    
    if user.save
      render status: 201, json: user
    else
      render status: 422, json: user.errors
    end
  end
  
  def update
    user = User.find(params[:id])
    
    if user.update(user_params)
      render status: 200, json: user
    else
      render status: 422, json: user.errors
    end
  end
  
  def email
    if User.find_by(email: params[:email])
      render status: 204, nothing: true
    else
      render status: 404, nothing: true
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
