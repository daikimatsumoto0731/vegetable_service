# frozen_string_literal: true

class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless line_bot_client.validate_signature(body, signature)
      head :bad_request
      return
    end

    events = line_bot_client.parse_events_from(body)
    events.each { |event| process_event(event) }

    head :ok
  end

  private

  def process_event(event)
    case event
    when Line::Bot::Event::Message
      # handle_message_event(event)  # 現在はこのイベントは処理しません。
    when Line::Bot::Event::Follow
      handle_follow_event(event)
    end
  end

  def line_bot_client
    @line_bot_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_MESSAGING_API_CHANNEL_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
    end
  end

  def handle_follow_event(event)
    user_id = event['source']['userId']
    User.find_or_create_by(line_user_id: user_id)
    # prompt_prefecture_message(event['replyToken'])  # 都道府県を尋ねる処理を削除
  end
end
