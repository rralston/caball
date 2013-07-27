class BlogsController < ApplicationController

  load_and_authorize_resource
  
  def create
    @blog = Blog.create(params[:blog])
    @blog.update_attributes(:user => current_user)
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