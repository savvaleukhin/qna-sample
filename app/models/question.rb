class Question < ActiveRecord::Base
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  accepts_nested_attributes_for :attachments, reject_if: -> (a) { a[:file].blank? }, allow_destroy: true

  private

  def update_reputation(method)
    diff = Reputation.calculate(self, method)
    reputation = self.user.reputation + diff
    self.user.update(reputation: reputation)
  end
end
