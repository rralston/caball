class CommentsController < ApplicationController

  load_and_authorize_resource
  before_filter :load_project
  
  def create
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