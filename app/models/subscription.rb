class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User"
  belongs_to :tracking_question, class_name: "Question"

  validates :subscriber_id, :tracking_question_id, presence: true
  validates :subscriber_id, uniqueness: { scope: :tracking_question_id }
end
