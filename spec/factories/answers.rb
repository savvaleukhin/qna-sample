FactoryGirl.define do
  sequence :body do |n|
    "Answer \##{n}"
  end

  factory :answer do
    body "MyText"
  end

  factory :answer_list, class: "Answer" do
    body
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end  
end
