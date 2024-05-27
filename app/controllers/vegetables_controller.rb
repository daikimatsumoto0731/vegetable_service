# frozen_string_literal: true

class VegetablesController < ApplicationController
  def index
    @vegetable = Vegetable.new
  end

  def create
    @vegetable = Vegetable.new(vegetable_params)
    if @vegetable.save
      redirect_to vegetables_path, notice: 'Vegetable was successfully created.'
    else
      render :index
    end
  end

  def schedule
    selected_vegetable = params[:selected_vegetable]
    selected_date = params[:sowing_date] # 修正: 選択された日付を取得

    if selected_vegetable.blank?
      redirect_to vegetables_path # 選択されていない場合は野菜選択画面にリダイレクト
    else
      # 選択された野菜をスケジュール画面に渡す
      # 修正: 選択された日付をセッションに保存
      session[:selected_date] = selected_date
      redirect_to events_path(selected_vegetable:)
    end
  end

  private

  def vegetable_params
    params.require(:vegetable).permit(:name, :sowing_date)
  end
end
