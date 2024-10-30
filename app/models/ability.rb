class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new  # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      can :read, Account
      can :manage, Account, user_id: user.id  # Users can only manage their own accounts
      can :create, Transaction
      can :read, Transaction, account: { user_id: user.id }
    end
  end
end
