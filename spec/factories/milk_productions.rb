FactoryBot.define do
  factory :milk_production do
    animal { nil }
    production_date { "2025-07-08" }
    quantity { "9.99" }
    period { "MyString" }
    notes { "MyText" }
    company { nil }
  end
end
