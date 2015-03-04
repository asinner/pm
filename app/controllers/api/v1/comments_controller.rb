class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user
  
  def create
    commentable = find_commentable(params)
    comment = Comment.new(commentable: commentable, body: params[:body])
    authorize comment
    
    if comment.save
      render status: 201, json: comment
    else
      render status: 422, json: comment.errors
    end
  end
end
