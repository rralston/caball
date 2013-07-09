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
  end
end