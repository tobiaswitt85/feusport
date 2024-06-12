# frozen_string_literal: true

class CreateScoreCompetitionResults < ActiveRecord::Migration[7.0]
  def change
    create_table :score_competition_results, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid
      t.string :name, limit: 100, null: false
      t.string :result_type, limit: 50, null: false
      t.boolean :hidden, default: false, null: false

      t.timestamps
    end
  end
end
