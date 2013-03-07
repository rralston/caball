class FriendshipsController < ApplicationController
  before_filter :require_login

  def create
    @friendship = current_user.friendships.create!(:friend_id => params[:friend_id])
    redirect_to :back, :flash => {info: "You are now following #{User.find(@friendship.friend_id).name}"}
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    redirect_to :back, alert: "You are no longer following #{User.find(@friendship.friend_id).name}"
  end
end
