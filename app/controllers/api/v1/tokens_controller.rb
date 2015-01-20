class Api::V1::TokensController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = loop do
        random_token = SecureRandom::uuid
        break random_token unless Token.exists(string: random_token)
      end
    else
      
    end
  end
end
