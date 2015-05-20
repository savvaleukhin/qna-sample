class UpdateReputationJob < ActiveJob::Base
  queue_as :default

  def perform(object, method, user_id)
    user = User.find(user_id)

    user.with_lock do
      diff = Reputation.calculate(object, method)
      reputation = user.reputation + diff
      user.update(reputation: reputation)
    end
  end
end
