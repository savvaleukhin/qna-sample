class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :user_id, :votable_id, :votable_type, :value, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: [1, -1]

  after_create :calculate_reputation
  before_destroy :rollback_reputation

  private

  def calculate_reputation
    if self.value == 1
      UpdateReputationJob.perform_later(self.votable, 'vote_up', self.votable.user_id)
    else
      UpdateReputationJob.perform_later(self.votable, 'vote_down', self.votable.user_id)
    end
  end

  def rollback_reputation
    if self.value == 1
      UpdateReputationJob.perform_later(self.votable, 'vote_down', self.votable.user_id)
    else
      UpdateReputationJob.perform_later(self.votable, 'vote_up', self.votable.user_id)
    end
  end
end
