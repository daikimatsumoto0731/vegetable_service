# frozen_string_literal: true

class UserController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to new_user_sessions_path, notice: I18n.t('flash.notices.user_registered')
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :prefecture, :password, :password_confirmation)
  end
end
