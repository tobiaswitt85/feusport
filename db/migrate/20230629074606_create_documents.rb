# frozen_string_literal: true

class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid
      t.string :title, limit: 200, null: false

      t.timestamps
    end
  end
end
