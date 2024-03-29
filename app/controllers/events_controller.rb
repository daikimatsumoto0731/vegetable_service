class EventsController < ApplicationController
  before_action :set_vegetable, only: [:update_sowing_date]

  def index
    @selected_vegetable = params[:selected_vegetable]&.downcase
    if @selected_vegetable.present?
      @vegetable = Vegetable.find_by('lower(name) = ?', @selected_vegetable)
      if @vegetable
        # 「種まき」イベントを最初に、残りは開始日に基づいてソート
        @events = @vegetable.events
                            .where.not(name: 'Button')
                            .order(Arel.sql("CASE WHEN name = '種まき' THEN 0 ELSE 1 END, start_date ASC"))
      else
        redirect_to events_path, alert: "#{@selected_vegetable} に該当する野菜は見つかりませんでした。" and return
      end
    else
      @events = Event.where.not(name: 'Button')
                     .order(Arel.sql("CASE WHEN name = '種まき' THEN 0 ELSE 1 END, start_date ASC"))
    end
  
    template_name = @vegetable ? @selected_vegetable : 'default'
    render template: "events/#{template_name}"
  end
  
  def advice
    @event = Event.find_by(id: params[:id])
    if @event
      vegetable_name = @event.vegetable.name.downcase
      partial_name = map_event_name_to_partial(@event.name, vegetable_name)
      render partial: "events/#{partial_name}", locals: { event: @event }, layout: false
    else
      render json: { error: 'Event not found' }, status: :not_found
    end
  end

  def update_sowing_date
    sowing_date = Date.parse(params[:sowing_date])
    @vegetable = Vegetable.find(params[:vegetable_id])

    ActiveRecord::Base.transaction do
      if @vegetable.update(sowing_date:)
        @vegetable.update_related_event_dates
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase), notice: '種まき日を更新しました。'
      else
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase), alert: '種まき日の更新に失敗しました。'
      end
    end
  rescue StandardError => e
    redirect_to events_path(selected_vegetable: @vegetable.name.downcase), alert: "更新中にエラーが発生しました: #{e.message}"
  end

  private

  def set_vegetable
    @vegetable = Vegetable.find_by(id: params[:vegetable_id])
    return if @vegetable

    redirect_to events_path, alert: '指定された野菜は見つかりませんでした。'
  end

  def map_event_name_to_partial(event_name, vegetable_name)
    event_key = case event_name
                when '種まき' then 'seed_sowing'
                when '発芽期間' then 'germination_period'
                when '間引き・雑草抜き・害虫駆除' then 'thinning_weeding_pest_control'
                when '収穫期間' then 'harvesting_period'
                end
    "advice_#{vegetable_name}_#{event_key}"
  end
end
