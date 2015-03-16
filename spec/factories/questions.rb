FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"

    factory :question_2 do
      title "Second question"
    end

    factory :question_with_user do
      user
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

  factory :question_with_answers, class: "Question" do
    title "Question with answers"
    body "Text of question with answers"

    transient do
      answers_count 2
    end

    after(:create) do |question, evaluator|
      create_list(:answer_list, evaluator.answers_count, question: question)
    end
  end
end
