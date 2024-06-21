# frozen_string_literal: true

module AnalyzeImageModule
  extend ActiveSupport::Concern

  included do
    require 'google/cloud/vision'
  end

  def analyze_image
    image = params[:image]
    vegetable_name = params[:vegetable_name]

    if image && vegetable_name.present?
      handle_image_analysis(image, vegetable_name)
    else
      handle_missing_image_or_name
    end
  rescue StandardError => e
    handle_analysis_error(e)
  end

  private

  def handle_image_analysis(image, vegetable_name)
    labels, translated_vegetable_name = analyze_image_labels(image, vegetable_name)
    if labels
      process_analysis_results(labels, translated_vegetable_name)
    else
      redirect_to_failure
    end
  end

  def analyze_image_labels(image, vegetable_name)
    image_path = image.tempfile.path
    Rails.logger.info "Image path: #{image_path}"

    translated_vegetable_name = translate_vegetable_name(vegetable_name)
    Rails.logger.info "Translated vegetable name: #{translated_vegetable_name}"

    credentials = JSON.parse(ENV.fetch('GOOGLE_APPLICATION_CREDENTIALS_JSON', nil))
    vision = Google::Cloud::Vision.image_annotator do |config|
      config.credentials = credentials
    end

    response = vision.label_detection image: image_path
    extract_labels(response, translated_vegetable_name)
  end

  def extract_labels(response, translated_vegetable_name)
    if response&.responses && !response.responses.empty?
      labels = response.responses[0].label_annotations.map(&:description)
      Rails.logger.info "Labels detected: #{labels.join(', ')}"
      [labels, translated_vegetable_name]
    else
      Rails.logger.error 'No labels were detected.'
      nil
    end
  end

  def process_analysis_results(labels, translated_vegetable_name)
    @care_guide = PerenualApiClient.fetch_species_care_guide(translated_vegetable_name)
    @labels = labels
    @vegetable_status = determine_vegetable_status(labels)
    render 'analyze_image'
  end

  def handle_missing_image_or_name
    flash[:alert] = I18n.t('flash.alerts.image_or_name_missing')
    redirect_to new_analyze_image_path
  end

  def handle_analysis_error(exception)
    Rails.logger.error "Failed to analyze image: #{exception.message}"
    flash[:alert] = I18n.t('flash.alerts.image_analysis_error', message: exception.message)
    redirect_to new_analyze_image_path
  end

  def redirect_to_failure
    flash[:alert] = I18n.t('flash.alerts.image_analysis_failed')
    redirect_to new_analyze_image_path
  end

  def translate_vegetable_name(name)
    Rails.logger.info "Translating vegetable name: #{name}"
    translated_name = AzureTranslationService.translate(name, 'EN')
    Rails.logger.info "Translated vegetable name: #{translated_name}"
    translated_name
  rescue StandardError => e
    Rails.logger.error "Failed to translate vegetable name: #{e.message}"
    name # 翻訳に失敗した場合は元の名前を使用
  end
end
