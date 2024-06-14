# frozen_string_literal: true

class CreateUserAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_accesses, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid, null: false
      t.references :competition, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end
  end
end
