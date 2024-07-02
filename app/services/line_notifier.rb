# frozen_string_literal: true

class LineNotifier
  include HTTParty
  base_uri 'https://notify-api.line.me'

  def initialize(access_token)
    @access_token = access_token
  end

  def send_message(message)
    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{@access_token}"
    }

    body = {
      message:
    }

    response = self.class.post('/api/notify', headers:, body:)
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.code == 200
      handle_success
    else
      handle_error(response.code, response.body)
    end
  end

  def handle_success
    Rails.logger.info('LINE notification sent successfully.')
  end

  def handle_error(code, body)
    case code
    when 400
      log_error("Bad Request: #{body}")
    when 401
      log_error("Unauthorized: #{body}")
    when 500
      log_error("Internal Server Error: #{body}")
    else
      log_error("Unknown Error: #{body}")
    end
  end

  def log_error(message)
    Rails.logger.error(message)
  end
end
