class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :null_session
  
  def authenticate_user
    return render status: 401, json: 'You must be authenticated to perform that action' if current_user.nil?
  end
  
  def authenticate_company
    return render status: 422, json: 'You must create a company to perform that action' if current_user.company.nil?
  end
  
  def current_user
    token = Token.find_by(string: request.headers['X-Auth-Token'])
    @user ||= token.user if request.headers['X-Auth-Token'] && token
  end
  
  def user_not_authorized
    render status: 403, json: { msg: 'You are not authorized for that resource' }
  end
end
