# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AnalyzeImage', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  let(:vegetable) { create(:vegetable, name: 'トマト', user:) }

  before do
    sign_in user
    visit event_path(vegetable.id)
  end

  it 'uploads an image and analyzes it' do
    click_link '画像を分析する'

    fill_in '野菜名を入力', with: vegetable.name
    attach_file '画像をアップロード', Rails.root.join('spec/fixtures/files/sample_vegetable.jpg')

    expect(page).to have_button('画像を分析する', disabled: false)

    click_button '画像を分析する'

    expect(page).to have_content('画像分析結果 - トマト')
    expect(page).to have_content('野菜の状態')
    expect(page).to have_content('育て方のポイント')
  end

  it 'displays an error message when no image is uploaded' do
    click_link '画像を分析する'

    fill_in '野菜名を入力', with: vegetable.name
    click_button '画像を分析する'

    expect(page).to have_content('画像または野菜の名前が提供されていません。')
    expect(page).to have_current_path(new_analyze_image_path)
  end

  it 'displays an error message when no vegetable name is provided' do
    click_link '画像を分析する'

    attach_file '画像をアップロード', Rails.root.join('spec/fixtures/files/sample_vegetable.jpg')
    click_button '画像を分析する'

    expect(page).to have_content('画像または野菜の名前が提供されていません。')
    expect(page).to have_current_path(new_analyze_image_path)
  end
end
