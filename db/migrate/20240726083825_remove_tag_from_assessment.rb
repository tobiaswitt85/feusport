# frozen_string_literal: true

class RemoveTagFromAssessment < ActiveRecord::Migration[7.0]
  def change
    remove_column :assessments, :tags
  end
end
