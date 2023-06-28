# frozen_string_literal: true

class ChangeCompetitionDate < ActiveRecord::Migration[7.0]
  def change
    execute 'DELETE FROM COMPETITIONS'
    remove_column :competitions, :date
    add_column :competitions, :date, :date
    change_column_null :competitions, :date, false
  end
end
