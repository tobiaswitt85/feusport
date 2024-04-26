# frozen_string_literal: true

class Score::ListAssessment < ApplicationRecord
  belongs_to :assessment
  belongs_to :list

  schema_validations
end
