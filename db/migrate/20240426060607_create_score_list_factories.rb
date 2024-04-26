# frozen_string_literal: true

class CreateScoreListFactories < ActiveRecord::Migration[7.0]
  def change
    create_table :score_list_factories, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid

      t.string :session_id, null: false, limit: 200
      t.references :discipline, null: false, type: :uuid
      t.string :name, limit: 100
      t.string :shortcut, limit: 50
      t.integer :track_count
      t.string :type, null: false
      t.references :before_result, type: :uuid
      t.references :before_list, type: :uuid
      t.integer :best_count
      t.string :status, limit: 50
      t.integer :track
      t.boolean :hidden, default: false, null: false
      t.boolean :separate_target_times, null: false, default: false
      t.boolean :single_competitors_first, default: true, null: false
      t.boolean :show_best_of_run, default: false, null: false

      t.timestamps
    end
  end
end
