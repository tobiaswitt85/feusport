# frozen_string_literal: true

class CreateScoreResultLists < ActiveRecord::Migration[7.0]
  def change
    create_table :score_result_lists, id: :uuid do |t|
      t.references :list, null: false, type: :uuid
      t.references :result, null: false, type: :uuid

      t.timestamps
    end

    add_foreign_key :score_result_lists, :score_results, column: :result_id
    add_foreign_key :score_result_lists, :score_lists, column: :list_id
  end
end
