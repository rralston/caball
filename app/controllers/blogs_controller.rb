class BlogsController < ApplicationController

  before_filter :require_login
  before_filter :load_user
  
  def create
    @user = User.find(params[:user_id])
    @blog = @user.blogs.build(params[:blog])
    @blog.user = current_user
    if @blog.save
      redirect_to @user, notice: "Blog was created."
    else
      render :new
    end
  end

  def edit
    search
    @user = User.find(params[:user_id])
    @blog = current_user.blogs.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @blog = current_user.blogs.find(params[:id])
    if @blog.update_attributes(params[:blog])
      redirect_to @user, notice: "Blog was updated."
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @blog = current_user.blogs.find(params[:id])
    @blog.destroy
    redirect_to @user, notice: "Blog was destroyed."
  end

private

  def load_user
    @blog = User.find(params[:user_id])
  end
end
