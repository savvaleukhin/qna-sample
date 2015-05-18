class Answer < ActiveRecord::Base
  include Votable
  include Reputable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user_id, :body, presence: true
  accepts_nested_attributes_for :attachments, reject_if: -> (a) { a[:file].blank? }, allow_destroy: true

  after_create :calculate_reputation

  scope :by_top, -> { order('accepted DESC') }

  def accept
    Answer.transaction do
      Answer.where(question_id: question_id, accepted: true).update_all(accepted: false)
      update(accepted: true)
    end

    update_reputation(self, __method__, self.user)
  end

  private

  def calculate_reputation
    update_reputation(self, :create, self.user)
  end
end
