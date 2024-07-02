# frozen_string_literal: true

class AddReceiveNotificationsToUserSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :user_settings, :receive_notifications, :boolean, default: true, null: false
  end
end
