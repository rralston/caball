class ActivitiesController < ApplicationController
  def index
    search
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.friend_ids, owner_type: "User").first(5)
  end
end
