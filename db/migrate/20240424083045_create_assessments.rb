# frozen_string_literal: true

class CreateAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :assessments, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid
      t.string :name, null: false, limit: 100
      t.references :discipline, null: false, type: :uuid
      t.references :band, null: false, type: :uuid

      t.timestamps
    end
  end
end
