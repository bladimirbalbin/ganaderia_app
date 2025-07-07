FactoryBot.define do
  factory :membership_plan do
    name { "MyString" }
    description { "MyText" }
    price { "9.99" }
    users_limit { 1 }
    duration_in_days { 1 }
    active { false }
  end
end
