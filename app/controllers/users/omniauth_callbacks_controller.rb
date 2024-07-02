# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def line
      basic_action
    end

    private

    def basic_action
      @omniauth = request.env['omniauth.auth']
      if @omniauth.present?
        @profile = find_or_initialize_profile(@omniauth)
        handle_new_record(@profile, @omniauth) if @profile.new_record?
        refresh_access_token(@profile, @omniauth)
        sign_in_and_redirect_user(@profile)
        send_line_message(@profile)
      else
        redirect_to new_user_session_path, alert: I18n.t('flash.alerts.line_auth_failed')
      end
    end

    def find_or_initialize_profile(omniauth)
      User.find_or_initialize_by(provider: omniauth['provider'], uid: omniauth['uid'])
    end

    def handle_new_record(profile, omniauth)
      profile.assign_attributes(profile_attributes(omniauth))
      profile.save!
    end

    def profile_attributes(omniauth)
      email = omniauth['info']['email'].presence || fake_email(omniauth['uid'], omniauth['provider'])
      username = omniauth['info']['name'].presence || 'LINE User'
      prefecture = '未設定'

      {
        email:,
        username:,
        password: Devise.friendly_token[0, 20],
        line_user_id: omniauth['uid'],
        prefecture:
      }
    end

    def refresh_access_token(profile, omniauth)
      profile.refresh_access_token(omniauth) if profile.respond_to?(:refresh_access_token)
    end

    def sign_in_and_redirect_user(profile)
      sign_in(:user, profile)
      redirect_to user_path(current_user), notice: I18n.t('flash.notices.login_success')
    end

    def fake_email(uid, provider)
      "#{uid}-#{provider}-#{SecureRandom.hex(5)}@example.com"
    end

    def send_line_message(user)
      return if user.line_user_id.blank?

      message = {
        type: 'text',
        text: 'アプリへのログインありがとうございます！こちらからも最新情報などお知らせします。'
      }

      client = Rails.application.config.line_bot_client
      client.push_message(user.line_user_id, message)
    end
  end
end
