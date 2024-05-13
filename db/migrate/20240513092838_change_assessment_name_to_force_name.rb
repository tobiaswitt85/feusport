# frozen_string_literal: true

class ChangeAssessmentNameToForceName < ActiveRecord::Migration[7.0]
  def change
    rename_column :assessments, :name, :forced_name
  end
end
