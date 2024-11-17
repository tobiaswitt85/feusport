# frozen_string_literal: true

class CreateTeamListRestrictions < ActiveRecord::Migration[7.0]
  def change
    create_table :team_list_restrictions, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid, null: false
      t.references :team1, foreign_key: { to_table: :teams }, type: :uuid, null: false
      t.references :team2, foreign_key: { to_table: :teams }, type: :uuid, null: false
      t.references :discipline, foreign_key: true, type: :uuid, null: false
      t.integer :restriction, null: false

      t.timestamps
    end

    add_index :team_list_restrictions, %i[team1_id team2_id discipline_id], unique: true, name: :index_team_list_restrictions_unique
  end
end
