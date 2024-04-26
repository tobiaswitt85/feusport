# frozen_string_literal: true

class CreateScoreResultListFactories < ActiveRecord::Migration[7.0]
  def change
    create_table :score_result_list_factories, id: :uuid do |t|
      t.references :list_factory, null: false, type: :uuid
      t.references :result, null: false, type: :uuid

      t.timestamps
    end

    add_foreign_key :score_result_list_factories, :score_list_factories, column: :list_factory_id
    add_foreign_key :score_result_list_factories, :score_results, column: :result_id
  end
end
