class AnswerPreviewSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :accepted
end
