# frozen_string_literal: true

FactoryBot.define do
  factory :vegetable do
    name { 'トマト' }
    sowing_date { '2024-06-01' }
    association :user
  end
end
