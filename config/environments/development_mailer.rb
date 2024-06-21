# frozen_string_literal: true

Rails.application.configure do
  # Mailer settings
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.example.com',
    port: 587,
    user_name: 'your_username',
    password: 'your_password',
    authentication: 'plain',
    enable_starttls_auto: true
  }
  config.action_mailer.perform_deliveries = true
  config.hosts.clear
end
