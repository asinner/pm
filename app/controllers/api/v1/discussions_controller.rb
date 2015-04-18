class Api::V1::DiscussionsController < ApplicationController
  before_action :authenticate_user
  
  def create
    project = Project.find(params[:project_id])
    discussion = Discussion.new(project: project, title: params[:title], user: current_user)
    authorize discussion
    
    if discussion.save
      render status: 201, json: discussion
    else
      render status: 422, json: discussion.errors
    end
  end

  def index
    project = Project.find(params[:project_id])
    authorize project, :list_discussions?
    authorize_company(project.company)
    render status: 200, json: project.discussions
  end
end
