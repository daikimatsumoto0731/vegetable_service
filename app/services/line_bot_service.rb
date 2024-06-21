# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class LineBotService
  OPENWEATHER_API_KEY = ENV.fetch('OPENWEATHER_API_KEY', nil)

  def self.send_daily_weather_message
    User.where.not(prefecture: nil).find_each do |user|
      weather_data = fetch_weather_data(user.prefecture)
      message_text = determine_message(weather_data)
      send_push_message(user.line_user_id, message_text) if user.line_user_id.present?
    end
  end

  def self.fetch_weather_data(prefecture)
    encoded_prefecture = URI.encode_www_form_component(prefecture)
    uri = URI("https://api.openweathermap.org/data/2.5/weather?q=#{encoded_prefecture},JP&appid=#{OPENWEATHER_API_KEY}&units=metric")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def self.determine_message(weather_data)
    return '天気情報の取得に失敗しました。' unless valid_weather_data?(weather_data)

    weather_main = weather_data.dig('weather', 0, 'main')
    description = weather_data.dig('weather', 0, 'description') || '情報なし'
    temp = weather_data.dig('main', 'temp')

    generate_message(weather_main, description, temp)
  end

  def self.send_push_message(line_user_id, message_text)
    message = { type: 'text', text: message_text }
    client = line_bot_client
    response = client.push_message(line_user_id, [message])
    handle_response(response, line_user_id, message_text)
  end

  def self.line_bot_client
    @line_bot_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_MESSAGING_API_CHANNEL_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
    end
  end

  def self.handle_response(response, line_user_id, _message_text)
    Rails.logger.info "Response Code: #{response.code}, Response Body: #{response.body}"
    if response.code.to_s == '200'
      Rails.logger.info "Message sent successfully to user ID: #{line_user_id}"
    else
      Rails.logger.error "Failed to send message to user ID: #{line_user_id}, Error: #{response.body}"
    end
  rescue StandardError => e
    Rails.logger.error "Exception occurred while sending message to user ID: #{line_user_id}: #{e.message}"
  end

  private

  def self.valid_weather_data?(weather_data)
    weather_data && weather_data['weather']
  end

  def self.generate_message(weather_main, description, temp)
    send("#{weather_main.downcase}_message", description, temp)
  rescue NoMethodError
    default_message(description, temp)
  end

  def self.rain_message(description, temp)
    format_message('雨', description, temp, '水やりは控えめにしてください。')
  end

  def self.snow_message(description, temp)
    format_message('雪', description, temp, '注意してください。')
  end

  def self.clear_message(description, temp)
    format_message('晴れ', description, temp, '水やりを忘れずに。')
  end

  def self.clouds_message(description, temp)
    format_message('曇り', description, temp, '適宜水やりを調整してください。')
  end

  def self.default_message(description, temp)
    format_message(description, description, temp)
  end

  def self.format_message(weather, description, temp, advice = '')
    "今日の天気は#{weather}（#{description}）。気温は#{temp}度です。#{advice}"
  end

  private_class_method :valid_weather_data?, :generate_message
  private_class_method :rain_message, :snow_message, :clear_message, :clouds_message, :default_message, :format_message
end
