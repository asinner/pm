class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user
  
  def index
    taskable = find_taskable(params)
    tasks = taskable.tasks

    authorize taskable, :taskable?

    if taskable.is_a?(Project)
      return render status: 402, json: 'You must renew your subscription before continuing' unless taskable.company.active?
    else
      return render status: 402, json: 'You must renew your subscription before continuing' unless taskable.project.company.active?
    end

    render status: 200, json: tasks
  end

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

    task.complete(params[:completed], current_user)
    
    task.update_attributes(task_params)

    if task.save
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
