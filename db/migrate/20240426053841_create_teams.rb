# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid
      t.references :band, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false, limit: 100
      t.integer :number, default: 1, null: false
      t.string :shortcut, default: '', null: false, limit: 50
      t.integer :lottery_number
      t.boolean :enrolled, default: false, null: false
      t.string :tags, array: true, default: []
      t.integer :fire_sport_statistics_team_id
      t.index [:fire_sport_statistics_team_id]
      t.timestamps
    end
  end
end
