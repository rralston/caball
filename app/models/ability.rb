class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, User
    
    # can read user and project event without logging in.
    can :read, User
    can :read, Project

    can [:dashboard, :profile, :dashboard_projects, :dashboard_events, :dashboard_conversations, :agent_names], User do
      user.persisted?
    end

    can [:step_1, :step_2, :step_3, :files_upload], User do
      user.persisted?
    end

    can [:update, :destroy, :custom_update], User do |user_under_action|
      user_under_action == user
    end

    can [:create], Project do
      user.persisted?
    end
    can [:update, :destroy, :files_upload], Project do |project|
      project.user == user
    end

    can :create, Friendship do
      user.persisted?
    end
    can :destroy, Friendship do |friendship|
      friendship.user == user
    end

    can [:create, :read], Comment do
      user.persisted?
    end
    can [:update, :destroy], Comment do |comment|
      comment.user == user
    end

    can [:create, :read], Blog do
      user.persisted?
    end
    can [:edit, :destroy, :update], Blog do |blog|
      blog.try(:user) == user
    end

    can [:create, :unlike], Like do
      user.persisted?
    end
    can :destroy, Like do |like|
      like.try(:user) == user
    end

    can [:new, :create, :send_message_generic], Conversation do
      user.persisted?
    end

    can [:empty_trash], Conversation

    can [:destroy,:reply,:read,:unread,:trash,:untrash,:index,:show, :get_messages], Conversation do |conversation|
      user.persisted? && user.mailbox.conversations.include?(conversation)
    end

    can :create, RoleApplication do
      user.persisted?
    end

    can :read, Role

    can :manage, Role do |role|
      user.persisted? && role.project.user_id == user.id
    end

    can [:approve, :un_approve], RoleApplication do |application|
      user.persisted? && application.role.project.user_id == user.id
    end

    can :create, Endorsement do |endorsement|
      user.persisted? &&
        user.friend_ids.include?(endorsement.receiver_id)
    end

    can [:index, :new, :create, :show, :invite_followers, :send_message_to_organizer, :load_more, :up_vote, :down_vote, :files_upload], Event

    can [:edit, :update], Event do |event|
      event.user == user
    end

    can [:attend], Event do |event|
      !event.attends.map(&:user).include?(user)
    end

    can [:unattend], Event do |event|
      event.attends.map(&:user).include?(user)
    end

  end
end