# frozen_string_literal: true

class CreateAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :assessments, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid
      t.string :forced_name, null: true, limit: 100
      t.references :discipline, null: false, type: :uuid
      t.references :band, null: false, type: :uuid
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
