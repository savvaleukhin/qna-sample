ThinkingSphinx::Index.define :comment, with: :real_time do
  # fields
  indexes body

  # attributes
  has user_id, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
