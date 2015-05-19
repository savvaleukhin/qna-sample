class Question < ActiveRecord::Base
  include Votable

  scope :published_last_day, -> { where(created_at: (Time.now.utc - 1.day)..Time.now.utc) }

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  accepts_nested_attributes_for :attachments, reject_if: -> (a) { a[:file].blank? }, allow_destroy: true
end
