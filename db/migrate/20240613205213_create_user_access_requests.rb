# frozen_string_literal: true

class CreateUserAccessRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :user_access_requests, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid, null: false
      t.references :sender, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.string :email, null: false, limit: 200
      t.text :text, null: false
      t.boolean :drop_myself, null: false, default: false

      t.timestamps
    end
  end
end
