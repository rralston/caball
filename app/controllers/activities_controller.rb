class ActivitiesController < ApplicationController

  before_filter :search

  def index
    @activities = Activity.order("created_at desc").where(:owner_id => current_user.friend_ids, :owner_type => 'User')
  end
end
