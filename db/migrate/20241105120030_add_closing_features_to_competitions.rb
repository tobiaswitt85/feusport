# frozen_string_literal: true

class AddClosingFeaturesToCompetitions < ActiveRecord::Migration[7.0]
  def change
    change_table :competitions, bulk: true do |t|
      t.datetime :locked_at
    end
  end
end
