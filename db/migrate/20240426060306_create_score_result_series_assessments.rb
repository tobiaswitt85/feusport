# frozen_string_literal: true

class CreateScoreResultSeriesAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :score_result_series_assessments, id: :uuid do |t|
      t.references :result, null: false, type: :uuid
      t.references :assessment, null: false

      t.timestamps
    end

    add_foreign_key :score_result_series_assessments, :score_results, column: :result_id
  end
end
