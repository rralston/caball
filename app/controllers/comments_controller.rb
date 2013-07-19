class CommentsController < ApplicationController

  load_and_authorize_resource
  # before_filter :load_project, :except => [:add_comment]
  
  def create
    @comment = Comment.create(params[:comment])
    @comment.update_attributes(:user => current_user)
    render 'comments/comment_create_response'
  end

  def edit
    search
  end

  def update
    if @comment.update_attributes(params[:comment])
      redirect_to @project, notice: "Comment was updated."
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @project, notice: "Comment was destroyed."
  end

  private

  def load_project
    @project = Project.find(params[:project_id])
  end
end