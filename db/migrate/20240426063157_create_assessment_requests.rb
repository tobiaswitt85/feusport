# frozen_string_literal: true

class CreateAssessmentRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :assessment_requests, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid
      t.references :assessment, null: false, foreign_key: true, type: :uuid
      t.string :entity_type, null: false, limit: 100
      t.integer :entity_id, null: false
      t.integer :assessment_type, default: 0, null: false
      t.integer :group_competitor_order, default: 0, null: false
      t.integer :relay_count, default: 1, null: false
      t.integer :single_competitor_order, default: 0, null: false
      t.integer :competitor_order, default: 0, null: false

      t.timestamps
    end
  end
end
