# frozen_string_literal: true

class AddBestScoresToFireSportStatisticsTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :fire_sport_statistics_teams, :best_scores, :jsonb, default: {}
  end
end
