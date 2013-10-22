class Users::SessionsController < Devise::SessionsController

  # def new
  #   redirect_to root_url, notice: notice
  # end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if @user.profile == nil || @user.location == nil || @user.location == ""
      redirect_to edit_user_path(@user)
    else
      redirect_back_or(after_sign_in_path_for(@user))
    end
  end

end