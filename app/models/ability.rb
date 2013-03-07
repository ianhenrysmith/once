class Ability
  include CanCan::Ability

  def initialize(user) 
    can :manage, Asset if user
    
    user ||= User.new # guest user (not logged in)

    can :read, :all
    
    can [:edit, :update], Post, user_id: user.id
    can :create, Post if user.can_create_post?
    
    can :manage, User, id: user.id
  end
end
