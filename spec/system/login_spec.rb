# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserLogins', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user, email: 'test@example.com', password: 'password') }

  it 'logs in an existing user' do
    visit new_user_session_path

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_content('ログインしました')
  end

  it 'shows an error message with invalid credentials' do
    visit new_user_session_path

    fill_in 'メールアドレス', with: 'wrong@example.com'
    fill_in 'パスワード', with: 'wrongpassword'

    click_button 'ログイン'

    expect(page).to have_content('メールアドレスまたはパスワードが違います。')
  end

  it 'provides a link to sign up' do
    visit new_user_session_path

    expect(page).to have_link('会員登録', href: new_user_registration_path)
  end

  it 'provides a link to login with LINE' do
    visit new_user_session_path

    expect(page).to have_link('LINEログイン', href: user_line_omniauth_authorize_path)
  end
end
