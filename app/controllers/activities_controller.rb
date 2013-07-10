class ActivitiesController < ApplicationController

  before_filter :search

  def index
    @activities = Activity.order("created_at desc").where(:owner_id => current_user.friend_ids, :owner_type => 'User')
  end

  def next_activities
    activities = Activity.order("created_at desc").
                  where(:owner_id => current_user.friend_ids, :owner_type => 'User').
                  paginate(:page => params[:page_number], :per_page => 5)
    render :json => activities.to_json(:include => [
                                                    :owner, 
                                                    :trackable
                                                  ]
                                                )
  end
end
