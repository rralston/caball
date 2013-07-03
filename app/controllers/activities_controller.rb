class ActivitiesController < ApplicationController
  def index
    @activities = Activity.order("created_at desc")
    search

   # activity = User.find(activity.trackable.user).profiles.present?
  end
end
