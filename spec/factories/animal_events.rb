FactoryBot.define do
  factory :animal_event do
    event_type { "MyString" }
    event_date { "2025-07-08" }
    description { "MyText" }
    animal { nil }
    user { nil }
    company { nil }
  end
end
