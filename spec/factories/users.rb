# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }

    trait :confirmed do
      confirmed_at { Faker::Time.backward }
    end
  end
end
