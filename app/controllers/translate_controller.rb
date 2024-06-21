# frozen_string_literal: true

class TranslateController < ApplicationController
  def translate
    text = params[:text]
    service = params[:service] || 'deepl'
    translated_text = translate_text(text, service)
    render json: { translatedText: translated_text }
  end

  private

  def translate_text(text, service)
    log_translation_start(text, service)
    translated_text = perform_translation(text, service)
    log_translation_result(translated_text)
    translated_text
  rescue StandardError => e
    log_translation_error(e)
    text # 翻訳に失敗した場合は元のテキストを使用
  end

  def log_translation_start(text, service)
    Rails.logger.info "Starting translation for: #{text} using #{service}"
  end

  def perform_translation(text, service)
    case service
    when 'azure'
      AzureTranslationService.translate(text) # AzureTranslationServiceのクラス名を修正
    else
      TranslationService.translate(text)
    end
  end

  def log_translation_result(translated_text)
    Rails.logger.info "Translation result: #{translated_text}"
  end

  def log_translation_error(error)
    Rails.logger.error "Failed to translate text: #{error.message}"
  end
end
