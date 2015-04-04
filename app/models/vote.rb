class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, :value, presence: true
  validates_uniqueness_of :user_id, scope: [:votable_id, :votable_type]
  validates_inclusion_of :value, in: [1, -1]
  #validate :ensure_not_author

  def ensure_not_author
    errors.add :user_id, "is the author" if votable.user_id == user_id
  end
end
