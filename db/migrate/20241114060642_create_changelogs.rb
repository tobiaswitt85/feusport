# frozen_string_literal: true

class CreateChangelogs < ActiveRecord::Migration[7.0]
  def change
    create_table :changelogs, id: :uuid do |t|
      t.date :date, null: false
      t.string :title, null: false, limit: 100
      t.text :md, null: false

      t.timestamps
    end
  end
end
