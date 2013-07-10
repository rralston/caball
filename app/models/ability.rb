class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, User
    can :read, User do
      user.persisted?
    end
    can [:update, :destroy], User do |user_under_action|
      user_under_action == user
    end

    can [:create, :read], Project do
      user.persisted?
    end
    can [:update, :destroy], Project do |project|
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

    can :create, Like do
      user.persisted?
    end
    can :destroy, Like do |like|
      like.try(:user) == user
    end

    can [:new, :create], Conversation do
      user.persisted?
    end
    can [:destroy,:reply,:read,:unread,:trash,:untrash,:index,:show] do |conversation|
      user.persisted? && user.mailbox.conversations.includes?(conversation)
    end
  end
end