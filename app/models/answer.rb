class Answer < ActiveRecord::Base
  include Votable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user_id, :body, presence: true
  accepts_nested_attributes_for :attachments, reject_if: -> (a) { a[:file].blank? }, allow_destroy: true

  before_destroy :rollback_reputation
  after_commit :calculate_reputation, on: :create
  after_commit :notify_question_owner, on: :create
  after_commit :notify_question_subscribers, on: :create
  after_save ThinkingSphinx::RealTime.callback_for(:answer)

  scope :by_top, -> { order('accepted DESC') }

  def accept
    Answer.transaction do
      Answer.where(
        question_id: question_id, accepted: true).update_all(accepted: false, updated_at: Time.now)
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
    UserMailer.new_answer_notification(self.question.user.email, self).deliver_later
  end

  def notify_question_subscribers
    NotifySubscribersJob.perform_later(self)
  end
end
