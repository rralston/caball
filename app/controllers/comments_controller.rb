class CommentsController < ApplicationController

  load_and_authorize_resource
  # before_filter :load_project, :except => [:add_comment]
  after_filter :clear_temp_photo_objects, :only => [:update, :create]

  def create
    params[:comment][:user] = current_user
    
    # if the remote image url is empty delete the attributes from params hash
    # if not deleted, it will fail to create as validation fails since image is not present
    if params[:comment][:photo_attributes][:remote_image_url].empty?
      params[:comment].delete(:photo_attributes)
    end

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

    if not @comment.valid?
      @error = @comment.errors.full_messages.join(', ')
      @comment = nil
    end
    
    render 'comments/comment_create_response'
  end

  def edit
    search
  end

  def update
    comment = Comment.find(params[:id])

    DeleteActivities.new( comment ).del_1_day_ago_updates

    if comment.update_attributes(params[:comment])
      render :json => comment.to_json()
    else
      render :text => false
    end
  end

  def destroy
    @comment.destroy
    render :json => @comment.to_json()
  end

  def files_upload
    
    if params['comment']['photo_attributes'].present? and params['comment']['photo_attributes']['image'].present?
      
      photo_object = Photo.new

      photo_object.update_attributes(:image => params['comment']['photo_attributes']['image'])

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

  private

  def load_project
    @project = Project.find(params[:project_id])
  end
end