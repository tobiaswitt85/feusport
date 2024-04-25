# frozen_string_literal: true

class CreateDisciplines < ActiveRecord::Migration[7.0]
  def change
    create_table :disciplines, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid, null: false
      t.string :name, null: false, limit: 100
      t.string :short_name, null: false, limit: 20
      t.string :key, null: false, limit: 10
      t.boolean :single_discipline, default: false, null: false
      t.boolean :like_fire_relay, default: false, null: false

      t.timestamps
    end
  end
end
