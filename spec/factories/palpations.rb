FactoryBot.define do
  factory :palpation do
    animal { nil }
    palpation_date { "2025-07-08" }
    result { "MyString" }
    veterinarian { "MyString" }
    notes { "MyText" }
    company { nil }
  end
end
