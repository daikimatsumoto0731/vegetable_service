# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    # PUT /resource/password
    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield resource if block_given?

      if resource.errors.empty?
        handle_successful_password_reset
      else
        handle_failed_password_reset
      end
    end

    private

    def handle_successful_password_reset
      resource.unlock_access! if unlockable?(resource)
      set_flash_message!(:notice, :password_changed) # カスタムのフラッシュメッセージ
      # パスワード再設定後にログイン画面にリダイレクト
      redirect_to new_user_session_path and return
    end

    def handle_failed_password_reset
      set_minimum_password_length
      respond_with resource
    end
  end
end
