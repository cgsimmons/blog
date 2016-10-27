class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      # if user.admin?
      #   can :manage, :all
      # else
      #   can :read, :all
      # end

      # Author can manage his/her post of comments
      can :manage, [Post, Comment] do |pc|
        pc.user == user
      end

      can [:edit, :update, :destroy], Comment do |a|
        a.user == user || a.post.user == user
      end

      # can [:edit, :destroy], [Post]
      #
      # can :destroy, Answer do |a|
      #   a.user == user || a.question.user == user
      # end
      #
      # can :manage, [Question, Answer] do |q|
      #   q.user == user
      # end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
