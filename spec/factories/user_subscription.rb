FactoryBot.define do
  factory :user_subscription do
    association :user
    association :subscription
    credit { 0 }
  end
end