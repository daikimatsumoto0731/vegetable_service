# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  validates :username, presence: true
  validates :prefecture, presence: true
  validates :line_user_id, presence: true, if: -> { provider == 'line' }

  has_one :line_notification_setting, dependent: :destroy
  has_one :user_setting, dependent: :destroy
  has_many :harvests, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :vegetables, dependent: :destroy # :dependentオプションを追加

  # OmniAuth認証データからユーザーを検索または作成します
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.assign_attributes(
      email: auth.info.email.presence || generate_email(auth),
      password: Devise.friendly_token[0, 20],
      username: auth.info.name.presence || 'LINE User',
      line_user_id: auth.uid,
      prefecture: '未設定'
    )
    user.save!
    user
  end

  def refresh_access_token(auth)
    self.access_token = auth.credentials.token
    self.token_expires_at = Time.zone.at(auth.credentials.expires_at) if auth.credentials.expires_at
    save!
  end

  private

  def self.generate_email(auth)
    "#{auth.uid}-#{auth.provider}-#{SecureRandom.hex(5)}@example.com"
  end

  private_class_method :generate_email
end
