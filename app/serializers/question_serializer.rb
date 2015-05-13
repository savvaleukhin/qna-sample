class QuestionSerializer < QuestionPreviewSerializer
  attributes :body

  has_many :answers
  has_many :comments
  has_many :attachments
end
