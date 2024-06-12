# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class AzureTranslationService
  AZURE_TRANSLATOR_KEY = ENV.fetch('AZURE_TRANSLATOR_KEY', nil)
  AZURE_TRANSLATOR_REGION = ENV.fetch('AZURE_TRANSLATOR_REGION', nil)
  AZURE_TRANSLATOR_ENDPOINT = 'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0'

  def self.translate(text, target_lang = 'en')
    uri = URI(AZURE_TRANSLATOR_ENDPOINT)
    uri.query = URI.encode_www_form({ 'api-version' => '3.0', 'to' => target_lang })

    request = Net::HTTP::Post.new(uri)
    request['Ocp-Apim-Subscription-Key'] = AZURE_TRANSLATOR_KEY
    request['Ocp-Apim-Subscription-Region'] = AZURE_TRANSLATOR_REGION
    request['Content-Type'] = 'application/json'

    request.body = [{ 'Text' => text }].to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    result = JSON.parse(response.body)
    raise "Translation API error: #{result['error']['message']}" unless response.is_a?(Net::HTTPSuccess)

    result[0]['translations'][0]['text']
  rescue StandardError => e
    Rails.logger.error "Failed to translate text: #{e.message}"
    text # 翻訳に失敗した場合は元の名前を使用
  end
end
