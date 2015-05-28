ThinkingSphinx::Index.define :user, with: :real_time do
  # fields
  indexes email

  # attributes
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
