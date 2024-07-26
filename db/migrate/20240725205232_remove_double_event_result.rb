# frozen_string_literal: true

class RemoveDoubleEventResult < ActiveRecord::Migration[7.0]
  def change
    execute <<~SQL.squish
      UPDATE score_results
      SET calculation_method = 2
      WHERE type = 'Score::DoubleEventResult'
    SQL

    remove_column :score_results, :type
  end
end
