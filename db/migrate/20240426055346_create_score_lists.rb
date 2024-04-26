# frozen_string_literal: true

class CreateScoreLists < ActiveRecord::Migration[7.0]
  def change
    create_table :score_lists, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid
      t.string :name, default: '', null: false, limit: 100
      t.string :shortcut, default: '', null: false, limit: 50
      t.integer :track_count, default: 2, null: false
      t.date :date
      t.boolean :show_multiple_assessments, default: true, null: false
      t.boolean :hidden, default: false, null: false
      t.boolean :separate_target_times, default: false, null: false
      t.boolean :show_best_of_run, default: false, null: false
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
