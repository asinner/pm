class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from InactiveSubscriptionException, with: :inactive_subscription
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  
  def find_taskable(params)
    klass = [Project, Task].detect { |c| params["#{c.name.underscore}_id"]}
    begin
      @taskable = klass.find(params["#{klass.name.underscore}_id"])      
    rescue NoMethodError
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def find_commentable(params)
    klass = [Discussion, Comment].detect { |c| params["#{c.name.underscore}_id"]}
    begin
      @commentable = klass.find(params["#{klass.name.underscore}_id"])      
    rescue NoMethodError
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def find_attachable(params)
    klass = [Project, Discussion, Task, Comment].detect { |c| params["#{c.name.underscore}_id"]}
    begin
      @attachable = klass.find(params["#{klass.name.underscore}_id"])      
    rescue NoMethodError
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def authenticate_user
    return render status: 401, json: {error: 'You must be authenticated to perform that action'} if current_user.nil?
  end
  
  def authenticate_company
    return render status: 422, json: {error: 'You must create a company to perform that action'} if current_user.companies.nil?
  end
  
  def current_user
    token = Token.find_by(string: request.headers['X-Auth-Token'])
    @user ||= token.user if request.headers['X-Auth-Token'] && token
  end
  
  def user_not_authorized
    render status: 403, json: { error: 'You are not authorized for that resource' }
  end

  def authorize_company(company)
    raise InactiveSubscriptionException unless company.active? 
  end

  def inactive_subscription
    return render status: 402, json: {msg: 'Please renew your subscription'}
  end
end
