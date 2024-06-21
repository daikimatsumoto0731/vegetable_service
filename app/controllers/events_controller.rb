# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_vegetable, only: %i[show]
  before_action :set_event, only: [:destroy]

  include AnalyzeImageModule
  include VegetableStatusModule

  def index
    events = Event.where(vegetable_id: params[:vegetable_id])
    render json: events.to_json(only: %i[id title start_date end_date color])
  end

  def show
    @selected_vegetable = params[:selected_vegetable]
    @sowing_date = params[:sowing_date]
    respond_to do |format|
      format.html
      format.json do
        render json: Event.where(vegetable_id: @vegetable.id).to_json(only: %i[id title start_date end_date color])
      end
    end
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event, status: :created
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy # @eventをインスタンス変数に修正
    head :no_content
  end

  def new_analyze_image
    # ページの初期表示用
  end

  private

  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :vegetable_id, :color)
  end

  def set_vegetable
    @vegetable = Vegetable.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
