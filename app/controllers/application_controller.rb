class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  def authenticate_user
    return render status: 401, nothing: true if current_user.nil?
  end
  
  def current_user
    token = Token.find_by(string: request.headers['X-Auth-Token'])
    @user ||= token.user if request.headers['X-Auth-Token'] && token
  end
end
