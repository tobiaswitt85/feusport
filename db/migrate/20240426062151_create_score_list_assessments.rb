# frozen_string_literal: true

class CreateScoreListAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :score_list_assessments, id: :uuid do |t|
      t.references :assessment, null: false, type: :uuid, foreign_key: true
      t.references :list, null: false, type: :uuid

      t.timestamps
    end
    add_foreign_key :score_list_assessments, :score_lists, column: :list_id
  end
end
