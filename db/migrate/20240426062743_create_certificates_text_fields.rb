# frozen_string_literal: true

class CreateCertificatesTextFields < ActiveRecord::Migration[7.0]
  def change
    create_table :certificates_text_fields, id: :uuid do |t|
      t.references :template, null: false, type: :uuid
      t.decimal :left, null: false
      t.decimal :top, null: false
      t.decimal :width, null: false
      t.decimal :height, null: false
      t.integer :size, null: false
      t.string :key, null: false, limit: 50
      t.string :align, null: false, limit: 50
      t.string :text, limit: 200
      t.string :font, default: 'regular', null: false, limit: 20
      t.string :color, default: '000000', null: false, limit: 20

      t.timestamps
    end

    add_foreign_key :certificates_text_fields, :certificates_templates, column: :template_id
  end
end
