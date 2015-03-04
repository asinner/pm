class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user
  
  def create
    taskable = find_taskable(params)
    task = Task.new(taskable: taskable, description: params[:description]);    
    authorize task
    return render status: 402, json: 'You must renew your subscription before continuing' unless task.project.company.active?
    
    if task.save
      render status: 201, json: task
    else
      render status: 422, json: task.errors
    end
  end
  
  def update
    task = Task.find(params[:id])
    authorize task
    return render status: 402, json: 'You must renew your subscription before continuing' unless task.project.company.active?
    
    if task.update(task_params)
      render status: 200, json: task
    else
      render status: 422, json: task.errors
    end
  end
  
  private
  
  def task_params
    params.require(:task).permit(:description)
  end
end
