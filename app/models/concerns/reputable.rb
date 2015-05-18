module Reputable
  extend ActiveSupport::Concern

  private

  def update_reputation(object, method, user)
    diff = Reputation.calculate(object, method)
    reputation = user.reputation + diff
    user.update(reputation: reputation)
  end
end
