# frozen_string_literal: true

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
    if response.is_a?(Net::HTTPSuccess)
      parse_success_response(response)
    else
      handle_error_response(response)
    end
  end

  def self.parse_success_response(response)
    care_guide = JSON.parse(response.body)
    Rails.logger.info "Care guide fetched successfully: #{care_guide}"

    if care_guide['data']
      extract_care_guide_sections(care_guide['data'])
    else
      log_error_and_return_empty("No 'data' key in care_guide: #{care_guide}")
    end
  rescue JSON::ParserError => e
    log_error_and_return_empty("JSON parsing error: #{e.message}")
  end

  def self.extract_care_guide_sections(data)
    sections = initialize_sections

    data.each do |guide|
      guide['section']&.each do |section|
        update_sections(sections, section)
        break if all_sections_filled?(sections)
      end
      break if all_sections_filled?(sections)
    end

    sections
  end

  def self.update_sections(sections, section)
    case section['type'].downcase
    when 'watering'
      sections[:watering] ||= translate_section(section)
    when 'sunlight'
      sections[:sunlight] ||= translate_section(section)
    when 'pruning'
      sections[:pruning] ||= translate_section(section)
    end
  end

  def self.initialize_sections
    {
      watering: nil,
      sunlight: nil,
      pruning: nil
    }
  end

  def self.all_sections_filled?(sections)
    sections.values.all?
  end

  def self.handle_error_response(response)
    log_error("HTTP Error: #{response.code} - #{response.message}, Body: #{response.body}")
    {}
  end

  def self.translate_section(section)
    original_description = section['description']
    translated_text = TranslationService.translate(original_description)
    translated_text || original_description
  end

  def self.log_error(message)
    Rails.logger.error message
  end

  def self.log_error_and_return_empty(message)
    log_error(message)
    {}
  end
end
