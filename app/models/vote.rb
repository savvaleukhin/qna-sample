class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, :value, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: [1, -1]
end
