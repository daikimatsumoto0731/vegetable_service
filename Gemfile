# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'activerecord-session_store'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.8'
gem 'devise-i18n'
gem 'dotenv-rails'
gem 'fullcalendar-rails'
gem 'google-cloud-vision'
gem 'httparty'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'json'
gem 'line-bot-api'
gem 'momentjs-rails'
gem 'net-http'
gem 'omniauth-line', '<= 2.1.2'
gem 'omniauth-rails_csrf_protection'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8'
gem 'rubocop', require: false
gem 'sassc-rails', '~> 2.1'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop-rails', require: false
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'dockerfile-rails', '>= 1.6'
  gem 'letter_opener'
  gem 'listen', '~> 3.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'shoulda-matchers', '~> 5.0'
end

group :production do
  gem 'pg', '~> 1.5'
end
