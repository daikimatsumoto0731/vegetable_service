# frozen_string_literal: true

class UserSettingsController < ApplicationController
  before_action :set_user_setting, only: %i[edit update]

  def edit; end

  def update
    if @user_setting.update(user_setting_params)
      redirect_to user_path(current_user), notice: I18n.t('flash.notices.settings_updated')
    else
      render :edit
    end
  end

  private

  def set_user_setting
    @user_setting = current_user.user_setting || current_user.create_user_setting
  end

  def user_setting_params
    params.require(:user_setting).permit(:watering_time, :receive_notifications)
  end
end
