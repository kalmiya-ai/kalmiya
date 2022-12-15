# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user
    user_agent { Faker::Internet.user_agent }
    created_from { Faker::Internet.public_ip_v4_address }
    last_accessed_from { Faker::Internet.public_ip_v4_address }
    last_accessed_at { Faker::Time.backward }

    trait :expired do
      after(:create) do |session|
        session.update_column :expires_at, 1.minute.ago
      end
    end
  end
end
