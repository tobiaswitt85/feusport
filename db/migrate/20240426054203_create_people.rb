# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid
      t.references :band, null: false, foreign_key: true, type: :uuid
      t.string :last_name, null: false, limit: 100
      t.string :first_name, null: false, limit: 100
      t.references :team, foreign_key: true, type: :uuid
      t.string :bib_number, limit: 50
      t.integer :registration_order, default: 0, null: false
      t.string :tags, array: true, default: []
      t.integer :fire_sport_statistics_person_id
      t.index [:fire_sport_statistics_person_id]
      t.timestamps
    end
  end
end
