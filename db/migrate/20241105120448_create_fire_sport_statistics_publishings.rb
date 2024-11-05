# frozen_string_literal: true

class CreateFireSportStatisticsPublishings < ActiveRecord::Migration[7.0]
  def change
    create_table :fire_sport_statistics_publishings, id: :uuid do |t|
      t.references :competition, foreign_key: true, type: :uuid, null: false
      t.references :user, foreign_key: true, type: :uuid, null: false

      t.datetime :published_at

      t.timestamps
    end
  end
end
