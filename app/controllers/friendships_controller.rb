class FriendshipsController < ApplicationController

  load_and_authorize_resource

  def create
    @friendship = current_user.friendships.create(:friend_id => params[:friend_id])
    render :json => { :created =>true,
                      :follower => current_user.to_json(),
                      :followers_count => @friendship.friend.followers.count,
                      :notice => "You are now following #{User.find(@friendship.friend_id).name}"
                    }
  end

  def destroy
    @friendship = current_user.friendships.where(:friend_id => params[:friend_id]).first
    @friendship.destroy
    render :json => { :destroyed => true,
                      :follower => @current_user.to_json(),
                      :followers_count => @friendship.friend.followers.count,
                      :notice => "You are no longer following #{User.find(@friendship.friend_id).name}"
                    }
  end
end