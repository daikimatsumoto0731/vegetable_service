# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VegetableRegistration', type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    sign_in user
    visit vegetables_path
  end

  it 'registers a new vegetable' do
    fill_in 'vegetable-name', with: 'トマト'
    fill_in 'sowing-date', with: '2024-06-01'
    click_button '登録'
    # 以下の行を修正します
    expect(page).to have_content('野菜育成スケジュール') # 日本語のフラッシュメッセージを確認します
  end

  it 'shows validation errors if form is submitted with invalid data' do
    fill_in 'vegetable-name', with: ''
    fill_in 'sowing-date', with: ''
    click_button '登録'
    expect(page).to have_content('名前を入力してください')
    expect(page).to have_content('種まき日を入力してください')
  end
end
