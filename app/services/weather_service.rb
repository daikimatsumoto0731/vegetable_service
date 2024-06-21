# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'cgi'

class WeatherService
  BASE_URL = 'https://api.openweathermap.org/data/2.5/weather'
  API_KEY = ENV.fetch('OPENWEATHER_API_KEY', nil) # .envファイルからAPIキーを取得

  @client = Net::HTTP.new(URI(BASE_URL).host, URI(BASE_URL).port)
  @client.use_ssl = true

  def self.fetch_weather(city)
    response = make_request(city)
    parse_response(response)
  rescue StandardError => e
    { error: "天気情報の取得に失敗しました: #{e.message}" }
  end

  class << self
    private

    def make_request(city)
      uri = build_uri(city)
      request = Net::HTTP::Get.new(uri)
      request['Accept'] = 'application/json'
      @client.request(request)
    end

    def build_uri(city)
      escaped_city = CGI.escape(city)
      URI("#{BASE_URL}?q=#{escaped_city}&appid=#{API_KEY}&units=metric&lang=ja")
    end

    def parse_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        { error: "天気情報の取得に失敗しました: #{response.code} #{response.message}" }
      end
    end
  end
end
