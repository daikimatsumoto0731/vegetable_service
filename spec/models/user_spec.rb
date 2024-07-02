# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end
  end
end

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is not valid without a username' do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without a prefecture' do
      user = build(:user, prefecture: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end
  end
end

RSpec.describe User, type: :model do
  context 'omniauth' do
    it 'creates a user from omniauth data' do
      auth = OmniAuth::AuthHash.new(provider: 'line', uid: '12345',
                                    info: { email: 'test@example.com', name: 'LINE User' })
      user = User.from_omniauth(auth)
      expect(user).to be_valid
      expect(user.provider).to eq('line')
      expect(user.uid).to eq('12345')
      expect(user.email).to eq('test@example.com')
      expect(user.username).to eq('LINE User')
      expect(user.prefecture).to eq('未設定')
    end
  end
end
