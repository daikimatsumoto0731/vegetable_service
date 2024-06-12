# frozen_string_literal: true

namespace :weather do
  desc "Send weather notifications to LINE based on each user's prefecture"
  task send_line_notification: :environment do
    User.find_each do |user|
      next unless user.line_user_id.present? && user.prefecture.present?

      weather_data = WeatherService.fetch_weather(user.prefecture)
      LineBotService.send_weather_message(user.line_user_id, weather_data)
    end
  end
end
