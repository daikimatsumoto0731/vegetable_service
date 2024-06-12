# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    # ユーザーの選択した都道府県に基づく天気情報を取得
    if @user.prefecture.present?
      weather_response = WeatherService.fetch_weather(@user.prefecture)
      @weather_info = weather_response['weather'] ? weather_response['weather'][0]['description'] : '情報が取得できませんでした'
      @temperature_info = weather_response['main'] ? "#{weather_response['main']['temp']} ℃" : '情報が取得できませんでした'
    else
      @weather_info = '都道府県が設定されていません'
      @temperature_info = ''
    end

    # ユーザーが登録した野菜の一覧を取得
    @vegetables = @user.vegetables
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールが更新されました'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :prefecture)
  end
end
