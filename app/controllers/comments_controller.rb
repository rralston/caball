class CommentsController < ApplicationController

  load_and_authorize_resource
  # before_filter :load_project, :except => [:add_comment]
  
  def create
    params[:comment][:user] = current_user
    @comment = Comment.create(params[:comment])

    # if the user tried to add a video, check if its valid or not.
    if params[:comment][:video_attributes][:url].present?
      if @comment.video.provider.nil?
        # delete the activity created for this creation and update
        Activity.where(:trackable_type => 'Comment', :trackable_id => @comment.id).destroy_all
        @comment.destroy
        @comment = nil
        @error = 'Video not found. Please try different url'
      end
    end
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