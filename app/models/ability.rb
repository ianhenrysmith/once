class Ability
  include CanCan::Ability

  def initialize(user)    
    user ||= User.new # guest user (not logged in)

    can :read, :all
    
    can :manage, Post, user_id: user.id
    can :manage, User, user_id: user.id
  end
end
