class BlogsController < ApplicationController

  load_and_authorize_resource
  
  def create
    @blog = Blog.create(params[:blog])
    @blog.update_attributes(:user => current_user)

    # if the user tried to add a video, check if its valid or not.
    if params[:blog][:video_attributes][:url].present?
      if @blog.video.provider.nil?
        # delete the activity created for this creation and update
        Activity.where(:trackable_type => 'Blog', :trackable_id => @blog.id).destroy_all
        @blog.destroy
        @blog = nil
        @error = 'Video not found. Please try different url'
      end
    end

    render 'blogs/blog_create_response'
  end

  def edit
    search
    @user = current_user
    @blog = current_user.blogs.find(params[:id])
  end

  def update
    @blog = current_user.blogs.find(params[:id])
    if @blog.update_attributes(params[:blog])
      redirect_to current_user, notice: "Blog was updated."
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    redirect_to current_user, notice: "Blog was destroyed."
  end
end