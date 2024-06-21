# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'tempfile'

Bundler.require(*Rails.groups)

Dotenv::Railtie.load if defined?(Dotenv::Railtie)

module VegetableService
  class Application < Rails::Application
    config.load_defaults 7.0
    config.i18n.default_locale = :ja
    config.active_record.sqlite3_production_warning = false
    config.time_zone = 'Asia/Tokyo'
    config.assets.paths << Rails.root.join('vendor/assets/javascripts')
    config.autoload_paths += %W[#{config.root}/app/services]
    config.encoding = 'utf-8'

    # Google Cloud credentialsを一時ファイルに書き込む設定
    if ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
      temp_file = Tempfile.new('google_application_credentials')
      temp_file.write(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
      temp_file.rewind
      ENV['GOOGLE_APPLICATION_CREDENTIALS'] = temp_file.path
      # デバッグ用の標準出力
      puts "Google Application Credentials set at: #{ENV['GOOGLE_APPLICATION_CREDENTIALS']}"
    else
      puts "GOOGLE_APPLICATION_CREDENTIALS_JSON is not set"
    end
  end
end
