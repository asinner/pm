class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user
  
  def show
    project = Project.find(params[:id])
    authorize project
    return render status: 402, json: {msg: 'Please renew your subscription'} unless project.company.active?
    
    render status: 200, json: project
  end
  
  def create
    company = Company.find(params[:company_id])
    authorize company    
    return render status: 402, json: {msg: 'Please renew your subscription'} unless company.active?
    
    project = company.projects.build(project_params)
    
    if project.save
      render status: 201, json: project
    else
      render status: 422, json: project.errors      
    end
  end
  
  def update
    project = Project.find(params[:id])
    authorize project
    return render status: 402, json: {msg: 'Please renew your subscription'} unless project.company.active?
    
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
