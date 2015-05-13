class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :accepted
  has_many :comments
  has_many :attachments
end
