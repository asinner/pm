class Api::V1::ProjectsUsersController < ApplicationController
  before_action :authenticate_user
  
  def create
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])
    join = ProjectsUser.new(project: project, user: user)
    authorize join
    
    if join.save
      render status: 201, json: join
    else
      render status: 422, json: join.errors
    end
  end
end
