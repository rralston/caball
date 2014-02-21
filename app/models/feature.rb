class Feature < ActiveRecord::Base
  extend Flip::Declarable

  strategy Flip::CookieStrategy
  strategy Flip::DatabaseStrategy
  strategy Flip::DeclarationStrategy
  default false

  # Declare your features here, e.g:
  #
  # feature :world_domination,
  #   default: true,
  #   description: "Take over the world."

  feature :events_feature
    default: false,
    description: "Users can add Events and Upvote/Downvote and Invite other users."
  end
    
end
