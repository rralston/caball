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
  
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

end