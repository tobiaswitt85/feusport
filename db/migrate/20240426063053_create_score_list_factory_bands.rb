# frozen_string_literal: true

class CreateScoreListFactoryBands < ActiveRecord::Migration[7.0]
  def change
    create_table :score_list_factory_bands, id: :uuid do |t|
      t.references :list_factory, null: false, type: :uuid
      t.references :band, null: false, type: :uuid

      t.timestamps
    end

    add_foreign_key :score_list_factory_bands, :score_list_factories, column: :list_factory_id
    add_foreign_key :score_list_factory_bands, :bands, column: :band_id
  end
end
