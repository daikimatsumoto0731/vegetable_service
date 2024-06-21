# frozen_string_literal: true

class VegetablesController < ApplicationController
  before_action :set_vegetable, only: %i[destroy]

  def index
    @vegetable = Vegetable.new
  end

  def create
    @vegetable = current_user.vegetables.build(vegetable_params)
    if @vegetable.save
      redirect_to vegetables_path, notice: I18n.t('flash.notices.vegetable_created')
    else
      render :index
    end
  end

  def create_and_redirect
    @vegetable = current_user.vegetables.build(vegetable_params)
    if @vegetable.save
      redirect_to event_path(id: @vegetable.id, selected_vegetable: @vegetable.name.downcase,
                             sowing_date: @vegetable.sowing_date)
    else
      render :index
    end
  end

  def destroy
    @vegetable.destroy
    redirect_to user_path(current_user), notice: I18n.t('flash.notices.vegetable_deleted')
  end

  def schedule
    selected_vegetable = params[:selected_vegetable]
    selected_date = params[:sowing_date]

    if selected_vegetable.blank?
      redirect_to vegetables_path
    else
      session[:selected_date] = selected_date
      redirect_to events_path(selected_vegetable:)
    end
  end

  private

  def set_vegetable
    @vegetable = Vegetable.find(params[:id])
  end

  def vegetable_params
    params.require(:vegetable).permit(:name, :sowing_date)
  end
end
