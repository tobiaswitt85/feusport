# frozen_string_literal: true

class AddDescriptionToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :description, :text
  end
end
