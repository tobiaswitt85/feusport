# frozen_string_literal: true

class CreateWkos < ActiveRecord::Migration[7.0]
  def change
    create_table :wkos, id: :uuid do |t|
      t.string :name, limit: 100, null: false
      t.string :slug, limit: 100, null: false
      t.string :subtitle, null: false
      t.text :description_md, null: false

      t.timestamps
    end

    add_index :wkos, :slug, unique: true
  end
end
