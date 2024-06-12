# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserRegistrations', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'displays the sign up page' do
    visit new_user_registration_path
    expect(page).to have_content('会員登録')
  end

  it 'signs up a new user' do
    visit new_user_registration_path

    fill_in 'user_username', with: 'testuser' # id属性を使用
    fill_in 'user_email', with: 'testuser@example.com' # id属性を使用
    select '東京都', from: 'user_prefecture' # id属性を使用
    fill_in 'user_password', with: 'password' # id属性を使用
    fill_in 'user_password_confirmation', with: 'password' # id属性を使用

    click_button '会員登録'

    expect(page).to have_content('アカウント登録が完了しました')
  end
end
