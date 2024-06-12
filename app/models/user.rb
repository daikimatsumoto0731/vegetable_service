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
  has_many :vegetables

  # OmniAuth認証データからユーザーを検索または作成します
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.presence || User.generate_email(auth)
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name.presence || 'LINE User'
      user.line_user_id = auth.uid
      user.prefecture = '未設定'
    end
  end

  def refresh_access_token(auth)
    self.access_token = auth.credentials.token
    self.token_expires_at = Time.zone.at(auth.credentials.expires_at) if auth.credentials.expires_at
    save!
  end
end
