ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes [title, body], as: :questions
  indexes user.email, as: :users, sortable: true
  indexes answers.body, as: :answers
  indexes comments.body, as: :comments

  # attributes
  has user_id, created_at, updated_at
end
