json.(@answer, :id, :body)

json.attachments @answer.attachments do |attachment|
  json.id attachment.id
  json.url attachment.file.url
  json.filename attachment.file.filename
end