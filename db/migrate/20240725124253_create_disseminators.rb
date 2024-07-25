# frozen_string_literal: true

class CreateDisseminators < ActiveRecord::Migration[7.0]
  def change
    create_table :disseminators, id: :uuid do |t|
      t.string :name, null: false
      t.string :lfv
      t.string :position
      t.string :email_address
      t.string :phone_number
      t.timestamps
    end
  end
end
