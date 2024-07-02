# frozen_string_literal: true

# config/initializers/google_cloud.rb

if ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
  require 'tempfile'
  require 'json'
  begin
    temp_file = Tempfile.new(['google_application_credentials', '.json'])
    temp_file.write(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
    temp_file.rewind
    ENV['GOOGLE_APPLICATION_CREDENTIALS'] = temp_file.path
    Rails.logger.info "Temporary credentials file created at: #{temp_file.path}"

    # ファイル内容のログ出力
    credentials_content = File.read(temp_file.path)
    Rails.logger.info "Temporary credentials file content: #{credentials_content}"

    # JSON形式の検証
    begin
      parsed_credentials = JSON.parse(credentials_content)
      Rails.logger.info 'Temporary credentials file is valid JSON'
      Rails.logger.info "Parsed credentials: #{parsed_credentials}"
    rescue JSON::ParserError => e
      Rails.logger.error "Temporary credentials file is not valid JSON: #{e.message}"
    end
  rescue StandardError => e
    Rails.logger.error "Failed to create temporary credentials file: #{e.message}"
  end
else
  Rails.logger.error 'GOOGLE_APPLICATION_CREDENTIALS_JSON is not set.'
end
