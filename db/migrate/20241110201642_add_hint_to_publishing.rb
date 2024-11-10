# frozen_string_literal: true

class AddHintToPublishing < ActiveRecord::Migration[7.0]
  def change
    add_column :fire_sport_statistics_publishings, :hint, :text
  end
end
