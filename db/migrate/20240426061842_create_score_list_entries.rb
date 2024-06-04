# frozen_string_literal: true

class CreateScoreListEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :score_list_entries, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid
      t.references :list, null: false, type: :uuid
      t.string :entity_type, null: false, limit: 50
      t.uuid :entity_id, null: false
      t.integer :track, null: false
      t.integer :run, null: false
      t.string :result_type, default: 'waiting', null: false, limit: 20
      t.integer :assessment_type, default: 0, null: false
      t.references :assessment, null: false, foreign_key: true, type: :uuid
      t.integer :time
      t.integer :time_left_target
      t.integer :time_right_target

      t.timestamps
    end
    add_foreign_key :score_list_entries, :score_lists, column: :list_id
  end
end
