# frozen_string_literal: true

class CreateSimpleAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :simple_accesses, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid, null: false
      t.string :name, null: false
      t.string :password_digest

      t.timestamps
    end
    add_index :simple_accesses, %i[competition_id name], unique: true
  end
end
