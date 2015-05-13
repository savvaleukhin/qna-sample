class QuestionPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at, :user_id
end
