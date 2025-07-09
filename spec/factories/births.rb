FactoryBot.define do
  factory :birth do
    animal { nil }
    birth_date { "2025-07-08" }
    calf_gender { "MyString" }
    calf_weight { "9.99" }
    calf_name { "MyString" }
    notes { "MyText" }
    company { nil }
  end
end
