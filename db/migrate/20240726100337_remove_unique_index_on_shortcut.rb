# frozen_string_literal: true

class RemoveUniqueIndexOnShortcut < ActiveRecord::Migration[7.0]
  def change
    remove_index :teams, name: :index_teams_on_competition_band_shortcut_number
  end
end
