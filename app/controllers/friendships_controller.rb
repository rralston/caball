class FriendshipsController < ApplicationController

  load_and_authorize_resource

  def create
    @friendship = current_user.friendships.where(:friend_id => params[:friend_id]).first

    # create friendship if only it doesn't exist. this check will prevent creation of multiple friendships when user clicks multiple times.
    if @friendship.nil?
      @friendship = current_user.friendships.create(:friend_id => params[:friend_id])
    end

    render :json => { :created =>true,
                      :follower => current_user.to_json(),
                      :followers_count => @friendship.friend.followers.count,
                      :notice => "You are now following #{User.find(@friendship.friend_id).name}"
                    }
  end

  def destroy
    @friendships = current_user.friendships.where(:friend_id => params[:friend_id]).destroy_all  # if at all there are dupplicate friendships, they will be destroyed.
    render :json => { :destroyed => true,
                      :follower => @current_user.to_json(),
                      :followers_count => @friendships.first.friend.followers.count,
                      :notice => "You are no longer following #{User.find(@friendships.first.friend_id).name}"
                    }
  end
end