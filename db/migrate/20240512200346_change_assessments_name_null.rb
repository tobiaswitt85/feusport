# frozen_string_literal: true

class ChangeAssessmentsNameNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :assessments, :name, true
  end
end
