class ActivitiesController < ApplicationController

  before_filter :search

  def index
    @activities = current_user.activities_feed
  end

  def next_activities
    activities = current_user.activities_feed.
                  paginate(:page => params[:page_number], :per_page => ACTIVITIES_PER_PAGE)
    render :json => activities.to_json(:include => [
                                                    :owner, 
                                                    :trackable
                                                  ],
                                                  :check_user => current_user
                                                )
  end
end
