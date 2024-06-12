require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      event = build(:event)
      expect(event).to be_valid
    end

    it 'is not valid without a title' do
      event = build(:event, title: nil)
      expect(event).to_not be_valid
    end

    it 'is not valid without a start_date' do
      event = build(:event, start_date: nil)
      expect(event).to_not be_valid
    end

    it 'is not valid without an end_date' do
      event = build(:event, end_date: nil)
      expect(event).to_not be_valid
    end

    it 'is not valid if end_date is before start_date' do
      event = build(:event, start_date: Date.today, end_date: Date.yesterday)
      expect(event).to_not be_valid
    end
  end

  describe '#duration_in_days' do
    it 'returns the correct duration in days' do
      event = build(:event, start_date: Date.today, end_date: Date.today + 5.days)
      expect(event.duration_in_days).to eq(5)
    end
  end
end