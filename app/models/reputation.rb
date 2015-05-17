class Reputation
  CREATING_ANSWER = 1
  FIRST_ANSWER = 1
  SELF_QUESTION = 2
  ACCEPT_ANSWER = 3
  VOTE_UP_ANSWER = 1
  VOTE_DOWN_ANSWER = -1
  VOTE_UP_QUESTION = 2
  VOTE_DOWN_QUESTION = -2

  def self.calculate(object, method)
    case object.class.name
    when 'Answer'
      case method
      when :create then create_answer_action(object)
      when :accept then return ACCEPT_ANSWER
      when :vote_up then return VOTE_UP_ANSWER
      when :vote_down then return VOTE_DOWN_ANSWER
      end
    when 'Question'
      case method
      when :vote_up then return VOTE_UP_QUESTION
        when :vote_down then return VOTE_DOWN_QUESTION
      end
    end
  end

  private

  def self.create_answer_action(object)
    question = object.question
    reputation = CREATING_ANSWER

    if question.answers.size == 1
      if question.user_id == object.user_id
        reputation += (FIRST_ANSWER + SELF_QUESTION)
      else
        reputation += FIRST_ANSWER
      end
    else
      reputation += SELF_QUESTION if question.user_id == object.user_id
    end
    reputation
  end
end
