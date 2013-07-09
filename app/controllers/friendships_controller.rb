class FriendshipsController < ApplicationController

  load_and_authorize_resource

  def create
    @friendship = current_user.friendships.create!(:friend_id => params[:friend_id])
    render :json => { :success => true, :created =>true, :friendship => @friendship, 
                      :fan_count => Friendship.where(:friend_id => params[:friend_id]).count, 
                      :notice => "You are now following #{User.find(@friendship.friend_id).name}"
                    }
  end

  def destroy
    @friendship.destroy
    render :json => { :success => true, :destroyed => true, :friendship => @friendship,
                      :fan_count => Friendship.where(:friend_id => @friendship.friend_id).count, 
                      :notice => "You are no longer following #{User.find(@friendship.friend_id).name}"
                    }
  end
end