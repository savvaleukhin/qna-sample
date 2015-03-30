class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  accepts_nested_attributes_for :attachments, reject_if: -> (a) { a[:file].blank? }, allow_destroy: true
end
