# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'TestUser' }
    email { 'test@example.com' }
    password { 'password' }
    prefecture { '東京都' }

    trait :line_user do
      provider { 'line' }
      uid { '12345' }
      line_user_id { '12345' }
    end
  end
end
