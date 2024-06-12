# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'tempfile' # Tempfileを使用するために追加

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load # dotenvを読み込む

module VegetableService
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.i18n.default_locale = :ja

    config.active_record.sqlite3_production_warning = false

    config.time_zone = 'Asia/Tokyo'

    config.assets.paths << Rails.root.join('vendor/assets/javascripts')

    config.autoload_paths += %W[#{config.root}/app/services]

    config.encoding = 'utf-8'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Google Cloud credentialsを一時ファイルに書き込む設定
    if ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
      temp_file = Tempfile.new('google_application_credentials')
      temp_file.write(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
      temp_file.rewind
      ENV['GOOGLE_APPLICATION_CREDENTIALS'] = temp_file.path
    end
  end
end
