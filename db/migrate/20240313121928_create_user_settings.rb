# frozen_string_literal: true

class CreateUserSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.time :watering_time

      t.timestamps
    end
  end
end
