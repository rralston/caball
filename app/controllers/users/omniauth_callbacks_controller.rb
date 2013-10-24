class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      if @user.returning_user?
        redirect_back_or('/dashboard')
      else
        redirect_back_or(edit_user_path(@user))
        @user.friendships.create(:friend_id => "1")
        @user.friendships.create(:friend_id => "2")
        @user.friendships.create(:friend_id => "4")
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end