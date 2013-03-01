class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, :all
    
    can :manage, Post, user_id: user.id
    cannot :create, Post unless user.can_create_post?
    
    can :manage, User, user_id: user.id
  end
end
