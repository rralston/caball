class Users::RegistrationsController < Devise::RegistrationsController

  # load_and_authorize_resource :except => [:new]

  def create
    build_resource(params[:user])

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        redirect_back_or(edit_user_path(resource))
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # def destroy
  #   current_user.update_attributes(:last_signout_time => Time.now)
  #   super
  # end

end