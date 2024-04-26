# frozen_string_literal: true

class CreateScoreListFactoryAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :score_list_factory_assessments, id: :uuid do |t|
      t.references :list_factory, null: false, type: :uuid
      t.references :assessment, null: false, type: :uuid

      t.timestamps
    end

    add_foreign_key :score_list_factory_assessments, :score_list_factories, column: :list_factory_id
    add_foreign_key :score_list_factory_assessments, :assessments, column: :assessment_id
  end
end
