# All Active Admin users are authorized using this class
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all

    unless user.admin?
      cannot :manage, User
    end

  end
end