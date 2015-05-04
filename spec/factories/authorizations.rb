FactoryGirl.define do
  factory :authorization do
    user nil
    provider "MyString"
    uid "123456"

    factory :facebook_authorization do
      provider "facebook"
    end

    factory :twitter_authorization do
      provider "twitter"
    end
  end
end
