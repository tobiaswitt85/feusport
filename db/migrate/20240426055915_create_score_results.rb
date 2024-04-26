# frozen_string_literal: true

class CreateScoreResults < ActiveRecord::Migration[7.0]
  def change
    create_table :score_results, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid
      t.string :name, default: '', null: false, limit: 100
      t.boolean :group_assessment, default: false, null: false
      t.references :assessment, null: false, foreign_key: true, type: :uuid
      t.references :double_event_result, foreign_key: false, type: :uuid
      t.string :type, default: 'Score::Result', null: false, limit: 50
      t.integer :group_score_count
      t.integer :group_run_count
      t.date :date
      t.integer :calculation_method, default: 0, null: false

      t.timestamps
    end

    add_foreign_key :score_results, :score_results, column: :double_event_result_id
  end
end
