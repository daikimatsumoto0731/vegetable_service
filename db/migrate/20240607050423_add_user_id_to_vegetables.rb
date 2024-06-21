# frozen_string_literal: true

class AddUserIdToVegetables < ActiveRecord::Migration[7.0]
  def change
    add_column :vegetables, :user_id, :integer
    add_index :vegetables, :user_id
    add_foreign_key :vegetables, :users
  end
end
