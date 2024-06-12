# frozen_string_literal: true

# WeatherServiceクラス
require 'net/http'
require 'uri'
require 'json'
require 'cgi'

class WeatherService
  BASE_URL = 'https://api.openweathermap.org/data/2.5/weather'
  @@client = Net::HTTP.new(URI(BASE_URL).host, URI(BASE_URL).port)
  @@client.use_ssl = true
  API_KEY = ENV.fetch('OPENWEATHER_API_KEY', nil) # .envファイルからAPIキーを取得

  def self.fetch_weather(city)
    escaped_city = CGI.escape(city)
    uri = URI("#{BASE_URL}?q=#{escaped_city}&appid=#{API_KEY}&units=metric&lang=ja")

    begin
      request = Net::HTTP::Get.new(uri)
      request['Accept'] = 'application/json'

      response = @@client.request(request)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        { error: "天気情報の取得に失敗しました: #{response.code} #{response.message}" }
      end
    rescue StandardError => e
      { error: "天気情報の取得に失敗しました: #{e.message}" }
    end
  end
end
