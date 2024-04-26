# frozen_string_literal: true

class Score::ListFactoryAssessment < ApplicationRecord
  belongs_to :assessment
  belongs_to :list_factory, class_name: 'Score::ListFactory'

  schema_validations
end
