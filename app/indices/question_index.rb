ThinkingSphinx::Index.define :question, with: :real_time do
  # fields
  indexes title
  indexes body

  # attributes
  has user_id, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
