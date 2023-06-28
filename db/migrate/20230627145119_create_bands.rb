# frozen_string_literal: true

class CreateBands < ActiveRecord::Migration[7.0]
  def change
    create_table :bands, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid, null: false

      t.integer :gender, null: false
      t.string :name, null: false
      t.integer :position

      t.timestamps
    end
  end
end
