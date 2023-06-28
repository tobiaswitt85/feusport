# frozen_string_literal: true

class AddUserToCompetition < ActiveRecord::Migration[7.0]
  def change
    execute 'DELETE FROM COMPETITIONS'
    add_reference :competitions, :user, foreign_key: true, type: :uuid
    change_column_null :competitions, :user_id, false
  end
end
