# frozen_string_literal: true

require 'line/bot'

# LINE Botの設定
Rails.application.config.line_bot_client = Line::Bot::Client.new do |config|
  config.channel_secret = ENV.fetch('LINE_MESSAGING_API_CHANNEL_SECRET', nil)
  config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
end
