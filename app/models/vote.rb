class Vote < ActiveRecord::Base
  include Reputable

  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, :value, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: [1, -1]

  after_create :calculate_reputation
  before_destroy :rollback_reputation

  private

  def calculate_reputation
    if self.value == 1
      update_reputation(self.votable, :vote_up, self.votable.user)
    else
      update_reputation(self.votable, :vote_down, self.votable.user)
    end
  end

  def rollback_reputation
    if self.value == 1
      update_reputation(self.votable, :vote_down, self.votable.user)
    else
      update_reputation(self.votable, :vote_up, self.votable.user)
    end
  end
end
