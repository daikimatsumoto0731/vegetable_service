# frozen_string_literal: true

class CreateLineNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :line_notification_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :receive_notifications, default: false, null: false
      t.string :frequency, default: 'daily'

      t.timestamps
    end
  end
end
