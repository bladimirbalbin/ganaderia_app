FactoryBot.define do
  factory :insemination do
    animal { nil }
    bull_name { "MyString" }
    insemination_date { "2025-07-08" }
    technician { "MyString" }
    notes { "MyText" }
    company { nil }
  end
end
