class Question < ActiveRecord::Base
  include Votable

  scope :published_last_day, -> { where(created_at: (Time.now.utc - 1.day).all_day) }

  SEARCH_OPTIONS = %i(everywhere questions answers comments users)

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, foreign_key: "tracking_question_id", dependent: :destroy
  has_many :subscribers, through: :subscriptions

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  accepts_nested_attributes_for :attachments, reject_if: -> (a) { a[:file].blank? }, allow_destroy: true

  def subscription_for(user_id)
    subscriptions.find_by(subscriber_id: user_id)
  end

  def subscribed_by?(user_id)
    subscriptions.where(subscriber_id: user_id).any?
  end

  private

  def self.search_filter(params)
    query = Riddle::Query.escape(params[:query])
    condition = params[:condition].to_sym

    return [] unless SEARCH_OPTIONS.include? condition

    case condition
    when SEARCH_OPTIONS[0]
      Question.search query
    else
      Question.search conditions: { condition => query }
    end
  end
end
