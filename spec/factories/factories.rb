require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { "abcdef" }
  end

  factory :entry do
    sequence(:task) { |n| "task#{n}"}
  end
end
