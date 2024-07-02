# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class TranslationService
  DEEPL_API_URL = 'https://api-free.deepl.com/v2/translate'
  DEEPL_API_KEY = ENV.fetch('DEEPL_API_KEY', nil)

  def self.translate(text, target_lang = 'JA')
    uri = URI(DEEPL_API_URL)
    params = {
      auth_key: DEEPL_API_KEY,
      text:,
      target_lang:
    }

    response = Net::HTTP.post_form(uri, params)
    result = JSON.parse(response.body)
    raise "Translation API error: #{result['message']}" unless response.is_a?(Net::HTTPSuccess)

    result['translations'][0]['text']
  end
end
