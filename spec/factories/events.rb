# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { 'Sample Event' }
    start_date { Time.zone.today }
    end_date { Time.zone.today + 1.week }
    association :vegetable
  end
end
