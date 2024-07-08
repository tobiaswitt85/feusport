# frozen_string_literal: true

class CreateScoreListPrintGenerators < ActiveRecord::Migration[7.0]
  def change
    create_table :score_list_print_generators, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid, null: false
      t.text :print_list

      t.timestamps
    end
  end
end
