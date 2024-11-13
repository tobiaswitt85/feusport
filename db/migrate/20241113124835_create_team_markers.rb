# frozen_string_literal: true

class CreateTeamMarkers < ActiveRecord::Migration[7.0]
  def change
    create_table :team_markers, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid
      t.string :name, limit: 20, null: false
      t.integer :value_type, default: 0, null: false

      t.timestamps
    end
  end
end
