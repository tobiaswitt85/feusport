# frozen_string_literal: true

class Score::ListAssessment < ApplicationRecord
  belongs_to :assessment, touch: true
  belongs_to :list

  schema_validations
end
