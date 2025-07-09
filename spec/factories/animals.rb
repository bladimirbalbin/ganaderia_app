FactoryBot.define do
  factory :animal do
    name { "MyString" }
    breed { "MyString" }
    birth_date { "2025-07-08" }
    weight { "9.99" }
    gender { "MyString" }
    ear_tag { "MyString" }
    status { "MyString" }
    company { nil }
  end
end
