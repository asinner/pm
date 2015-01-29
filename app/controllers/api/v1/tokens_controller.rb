class Api::V1::TokensController < ApplicationController
  def create        
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = loop do
        random_token = SecureRandom::uuid
        break random_token unless Token.exists?(string: random_token)
      end
      
      token = Token.create(user: user, string: token, expires_at: 1.year.from_now)
      render status: 201, json: token
    else
      render status: 401, nothing: true
    end
  end
  
  def destroy
    token = Token.find_by(string: params[:id])
    token.delete if token
    render status: 204, nothing: true
  end
end
