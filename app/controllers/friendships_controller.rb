class FriendshipsController < ApplicationController
  before_filter :require_login

  def create
    @friendship = current_user.friendships.create!(:friend_id => params[:friend_id])
    #new_link = current_user.friendships.find_by_friend_id(@user.id)
    #redirect_to :back, alert: "You are no longer following #{User.find(@friendship.friend_id).name}"
    render :json => {:success => true, :created =>true, :friendship => @friendship, :fan_count => Friendship.where(:friend_id => params[:friend_id]).count, :notice => "You are now following #{User.find(@friendship.friend_id).name}"}
  end

  def destroy
    friend_id = current_user.friendships.find(params[:id]).friend_id
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    #redirect_to :back, alert: "You are no longer following #{User.find(@friendship.friend_id).name}"
    render :json => {:success => true, :destroyed => true, :friendship => @friendship, :fan_count => Friendship.where(:friend_id => friend_id).count, :notice => "You are no longer following #{User.find(@friendship.friend_id).name}"}
  end
end
