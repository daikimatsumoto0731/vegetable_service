# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class AzureTranslationService
  AZURE_TRANSLATOR_KEY = ENV.fetch('AZURE_TRANSLATOR_KEY', nil)
  AZURE_TRANSLATOR_REGION = ENV.fetch('AZURE_TRANSLATOR_REGION', nil)
  AZURE_TRANSLATOR_ENDPOINT = 'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0'

  def self.translate(text, target_lang = 'en')
    uri = build_uri(target_lang)
    request = build_request(uri, text)
    response = send_request(uri, request)
    parse_response(response)
  rescue StandardError => e
    handle_error(e, text)
  end

  private

  def self.build_uri(target_lang)
    uri = URI(AZURE_TRANSLATOR_ENDPOINT)
    uri.query = URI.encode_www_form({ 'api-version' => '3.0', 'to' => target_lang })
    uri
  end

  def self.build_request(uri, text)
    request = Net::HTTP::Post.new(uri)
    request['Ocp-Apim-Subscription-Key'] = AZURE_TRANSLATOR_KEY
    request['Ocp-Apim-Subscription-Region'] = AZURE_TRANSLATOR_REGION
    request['Content-Type'] = 'application/json'
    request.body = [{ 'Text' => text }].to_json
    request
  end

  def self.send_request(uri, request)
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def self.parse_response(response)
    result = JSON.parse(response.body)
    raise "Translation API error: #{result['error']['message']}" unless response.is_a?(Net::HTTPSuccess)

    result[0]['translations'][0]['text']
  end

  def self.handle_error(error, text)
    Rails.logger.error "Failed to translate text: #{error.message}"
    text # 翻訳に失敗した場合は元のテキストを返す
  end

  private_class_method :build_uri, :build_request, :send_request, :parse_response, :handle_error
end
