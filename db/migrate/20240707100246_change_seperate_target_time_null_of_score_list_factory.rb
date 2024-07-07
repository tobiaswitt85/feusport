# frozen_string_literal: true

class ChangeSeperateTargetTimeNullOfScoreListFactory < ActiveRecord::Migration[7.0]
  def change
    change_column_null :score_list_factories, :separate_target_times, true
    change_column_default :score_list_factories, :separate_target_times, nil
  end
end
