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
    add_index :teams, %i[competition_id band_id name number], unique: true
    add_index :teams, %i[competition_id band_id shortcut number], unique: true, name: :index_teams_on_competition_band_shortcut_number

    create_table :team_relays, id: :uuid do |t|
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.integer :number, default: 1, null: false
      t.timestamps
    end
  end
end
