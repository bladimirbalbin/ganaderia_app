FactoryBot.define do
  factory :weight_record do
    animal { nil }
    weight_date { "2025-07-08" }
    weight { "9.99" }
    notes { "MyText" }
    company { nil }
  end
end
