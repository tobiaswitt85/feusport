# frozen_string_literal: true

class CreateCertificatesTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :certificates_templates, id: :uuid do |t|
      t.references :competition, null: false, foreign_key: true, type: :uuid
      t.string :name, limit: 200, null: false

      t.timestamps
    end
  end
end
