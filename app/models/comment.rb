class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, :user_id, :commentable_id, :commentable_type, presence: true

  after_save ThinkingSphinx::RealTime.callback_for(:comment)
end
