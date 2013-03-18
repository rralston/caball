class CommentsController < ApplicationController

  before_filter :require_login
  before_filter :load_project
  
  def create
    @project = Project.find(params[:project_id])
    @comment = @project.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      redirect_to @project, notice: "Comment was created."
    else
      render :new
    end
  end

  def edit
    search
    @project = Project.find(params[:project_id])
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @comment = current_user.comments.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to @project, notice: "Comment was updated."
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to @project, notice: "Comment was destroyed."
  end

private

  def load_project
    @comment = Project.find(params[:project_id])
  end
end
