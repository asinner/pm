class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_company
  
  def create
    project = current_user.company.projects.build(project_params)
    
    if project.save
      render status: 201, json: project
    else
      render status: 422, json: project.errors      
    end
  end
  
  def update
    project = Project.find(params[:id])
    authorize project
    
    if project.update(project_params)
      render status: 200, json: project
    else
      render status: 422, json: project.errors
    end
  end
  
  private
  
  def project_params
    params.require(:project).permit(:name, :description)
  end
end
