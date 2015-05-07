FactoryGirl.define do
  factory :comment do
    body "My comment"

    factory :comment_for_question do
      association :commentable, factory: :question_with_user
    end
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
  end
end
