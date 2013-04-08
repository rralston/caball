class ActivitiesController < ApplicationController
  def index
    search
    @activities = PublicActivity::Activity.order("created_at desc")
  end
end
