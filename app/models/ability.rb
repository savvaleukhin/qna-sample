class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, Question
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user_id: user.id

    can :destroy, Attachment do |attachment|
      attachment.attachmentable.user_id == user.id
    end

    can :accept, Answer do |answer|
      answer.question.user_id == user.id
    end

    can :vote, [Question, Answer] do |object|
      object.user_id != user.id
    end

    can :unvote, [Question, Answer] do |object|
      object.user_id != user.id
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
