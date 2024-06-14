# frozen_string_literal: true

class CreateCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions, id: :uuid do |t|
      t.string :name, limit: 50, null: false
      t.date :date, null: false
      t.string :locality, limit: 50, null: false
      t.string :slug, limit: 50, null: false
      t.integer :year, null: false
      t.boolean :visible, null: false, default: false
      t.text :description
      t.boolean :lottery_numbers, default: false, null: false
      t.boolean :show_bib_numbers, default: false, null: false

      t.timestamps
    end

    add_index :competitions, :date
    add_index :competitions, %i[year slug], unique: true
  end
end
