class BlogsController < ApplicationController

  load_and_authorize_resource
  after_filter :clear_temp_photo_objects, :only => [:update, :create]
  
  def create
    params[:blog][:user] = current_user
    # if the remote image url is empty delete the attributes from params hash
    # if not deleted, it will fail to create as validation fails since image is not present
    if params[:blog][:photo_attributes][:remote_image_url].empty?
      params[:blog].delete(:photo_attributes)
    end

    @blog = Blog.create(params[:blog])

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

    if not @blog.valid?
      @error = @blog.errors.full_messages.join(', ')
      @blog = nil
    end

    render 'blogs/blog_create_response'
  end

  def edit
    search
    @user = current_user
    @blog = current_user.blogs.find(params[:id])
  end

  def update
    blog = Blog.find(params[:id])
    if blog.update_attributes(params[:blog])
      render :json => blog.to_json()
    else
      render :text => false
    end
  end

  def destroy
    blog = Blog.find(params[:id])
    blog.destroy
    render :json => blog.to_json()
  end

   def files_upload
    
    if params['blog']['photo_attributes'].present? and params['blog']['photo_attributes']['image'].present?
      
      photo_object = Photo.new

      photo_object.update_attributes(:image => params['blog']['photo_attributes']['image'])

      if  Rails.env == 'development'
        url = request.env["HTTP_ORIGIN"] + photo_object.image.url
      else
        url = photo_object.image.url
      end
      
      file_url = {
        :url => url,
        :id => photo_object.reload.id
      }

    end

    render :json => file_url.to_json()
  end
end