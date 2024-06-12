# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'トップページが正常に表示されること' do
    visit root_path
    expect(page).to have_content('無NO薬〜野菜栽培〜')
    expect(page).to have_content('自宅で簡単に始める無農薬野菜作り')
  end

  it '会員登録リンクが正しいパスに遷移すること' do
    visit root_path
    click_link '会員登録'
    expect(page).to have_current_path(new_user_registration_path)
  end

  it 'ログインリンクが正しいパスに遷移すること' do
    visit root_path
    click_link 'ログイン'
    expect(page).to have_current_path(new_user_session_path)
  end

  it '利用規約リンクが正しいパスに遷移すること' do
    visit root_path
    click_link '利用規約'
    expect(page).to have_current_path(terms_path)
  end

  it 'プライバシーポリシーリンクが正しいパスに遷移すること' do
    visit root_path
    click_link 'プライバシーポリシー'
    expect(page).to have_current_path(privacy_policy_path)
  end
end
