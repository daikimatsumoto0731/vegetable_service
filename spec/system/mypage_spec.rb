# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MyPage', type: :system do
  let(:user) { create(:user) }
  let!(:vegetable) { create(:vegetable, user:) }

  before do
    driven_by(:rack_test)
    sign_in user
    visit user_path(user)
  end

  it "displays the user's profile information" do
    expect(page).to have_content("ようこそ#{user.username}さん")
  end

  it 'displays the weather information if prefecture is set' do
    user.update(prefecture: 'Tokyo')
    # データの再読み込み
    user.reload
    visit user_path(user)
    expect(page).to have_content('Tokyoの現在の天気')
  end

  it 'displays the registered vegetables' do
    expect(page).to have_content(vegetable.name)
  end

  it 'has a link to logout' do
    expect(page).to have_link('ログアウト', href: destroy_user_session_path)
  end

  it 'has a link to edit profile' do
    expect(page).to have_link('プロフィールを編集', href: edit_user_path(user))
  end
end
