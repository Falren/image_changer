FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:age) { |n| n }
    email { 'email_example@mail.com' }
    password { 'password123' }
  end
end