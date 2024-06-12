# frozen_string_literal: true

class CreateScoreCompetitionResultReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :score_competition_result_references, id: :uuid do |t|
      t.references :result, foreign_key: { to_table: :score_results }, type: :uuid, null: false
      t.references :competition_result, foreign_key: { to_table: :score_competition_results }, type: :uuid, null: false, index: false

      t.timestamps
    end

    add_index :score_competition_result_references, :competition_result_id, name: :index_score_competition_result_references_on_competition_result
  end
end
