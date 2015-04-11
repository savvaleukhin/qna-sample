json.(@answer, :id, :body, :question_id, :user_id)

json.attachments @answer.attachments do |attachment|
  json.id attachment.id
  json.url attachment.file.url
  json.filename attachment.file.filename
end