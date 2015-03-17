FactoryGirl.define do
  sequence :body do |n|
    "Answer \##{n}"
  end

  factory :answer do
    body "MyText"
  end

  factory :answer_with_question, class: "Answer" do
    body
    question

    factory :answer_with_user do
      body "User's answer"
      user
    end
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end  
end
