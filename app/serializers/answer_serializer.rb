class AnswerSerializer < AnswerPreviewSerializer
  has_many :comments
  has_many :attachments
end
