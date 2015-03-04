class Api::V1::AssignmentsController < ApplicationController
  before_action :authenticate_user
  
  def create
    task = Task.find(params[:task_id])
    user = User.find(params[:user_id])
    assignment = Assignment.new(task: task, user: user, assigner: current_user)
    authorize assignment
    
    if assignment.save
      render status: 201, json: assignment
    else
      render status: 422, json: assignment.errors
    end
  end
end
