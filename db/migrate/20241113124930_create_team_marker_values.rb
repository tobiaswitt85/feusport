# frozen_string_literal: true

class CreateTeamMarkerValues < ActiveRecord::Migration[7.0]
  def change
    create_table :team_marker_values, id: :uuid do |t|
      t.references :team_marker, foreign_key: true, type: :uuid, null: false
      t.references :team, foreign_key: true, type: :uuid, null: false
      t.boolean :boolean_value, null: false, default: false
      t.date :date_value
      t.text :string_value

      t.timestamps
    end

    add_index :team_marker_values, %i[team_marker_id team_id], unique: true
  end
end
