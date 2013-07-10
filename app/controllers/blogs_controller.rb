class BlogsController < ApplicationController

  load_and_authorize_resource
  
  def create
    @blog = current_user.blogs.build(params[:blog])
    if @blog.save
      redirect_to @user, notice: "Blog was created."
    else
      render :new
    end
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