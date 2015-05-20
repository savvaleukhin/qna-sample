class Answer < ActiveRecord::Base
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user_id, :body, presence: true
  accepts_nested_attributes_for :attachments, reject_if: -> (a) { a[:file].blank? }, allow_destroy: true

  after_create :notify_question_owner
  after_create :notify_question_subscribers
  before_destroy :rollback_reputation

  after_commit :calculate_reputation, on: :create

  scope :by_top, -> { order('accepted DESC') }

  def accept
    Answer.transaction do
      Answer.where(question_id: question_id, accepted: true).update_all(accepted: false)
      update(accepted: true)
    end

    UpdateReputationJob.perform_later(self, 'accept', self.user_id)
  end

  private

  def calculate_reputation
    UpdateReputationJob.perform_later(self, 'create', self.user_id)
  end

  def rollback_reputation
    UpdateReputationJob.perform_later(self, 'destroy', self.user_id)
  end

  def notify_question_owner
    UserMailer.delay.new_answer_notification(self.question.user.email, self)
  end

  def notify_question_subscribers
    NotifySubscribersJob.perform_later(self)
  end
end
