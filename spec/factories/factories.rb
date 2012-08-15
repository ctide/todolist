require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { "abcdef" }
  end
end
