# frozen_string_literal: true

every 1.day, at: '7:00 am' do
  runner 'LineBotService.send_daily_message'
end
