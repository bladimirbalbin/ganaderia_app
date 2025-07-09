FactoryBot.define do
  factory :medical_record do
    animal { nil }
    date { "2025-07-08" }
    diagnosis { "MyText" }
    treatment { "MyText" }
    veterinarian { "MyString" }
    notes { "MyText" }
  end
end
