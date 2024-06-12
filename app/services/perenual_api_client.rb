# frozen_string_literal: true

# app/services/perenual_api_client.rb

require 'net/http'
require 'uri'
require 'json'

class PerenualApiClient
  BASE_URL = 'https://perenual.com/api'

  def self.api_key
    ENV['PERENUAL_API_KEY'] || raise('PERENUAL_API_KEY is not set')
  end

  def self.fetch_species_care_guide(vegetable_name = nil)
    query_param = vegetable_name ? "&q=#{URI.encode_www_form_component(vegetable_name)}" : ''
    url = "#{BASE_URL}/species-care-guide-list?key=#{api_key}#{query_param}"
    uri = URI(url)

    Rails.logger.info "Fetching care guide with URL: #{url}"
    response = Net::HTTP.get_response(uri)

    handle_response(response)
  end

  def self.handle_response(response)
    case response
    when Net::HTTPSuccess
      begin
        care_guide = JSON.parse(response.body)
        Rails.logger.info "Care guide fetched successfully: #{care_guide}"

        if care_guide['data']
          Rails.logger.info "Data present in care guide: #{care_guide['data']}"
          first_watering = nil
          first_sunlight = nil
          first_pruning = nil

          care_guide['data'].each do |guide|
            guide['section']&.each do |section|
              case section['type'].downcase
              when 'watering'
                first_watering ||= translate_section(section)
              when 'sunlight'
                first_sunlight ||= translate_section(section)
              when 'pruning'
                first_pruning ||= translate_section(section)
              end

              # If we have all three sections, break the loop
              break if first_watering && first_sunlight && first_pruning
            end
            # If we have all three sections, break the loop
            break if first_watering && first_sunlight && first_pruning
          end

          {
            watering: first_watering,
            sunlight: first_sunlight,
            pruning: first_pruning
          }
        else
          Rails.logger.error "No 'data' key in care_guide: #{care_guide}"
          {}
        end
      rescue JSON::ParserError => e
        log_error("JSON parsing error: #{e.message}")
        {}
      end
    else
      log_error("HTTP Error: #{response.code} - #{response.message}, Body: #{response.body}")
      {}
    end
  end

  def self.translate_section(section)
    original_description = section['description']
    translated_text = TranslationService.translate(original_description)
    translated_text || original_description
  end

  def self.log_error(message)
    Rails.logger.error message
  end
end
