ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title
  indexes body

  # attributes
  has user_id, created_at, updated_at
end