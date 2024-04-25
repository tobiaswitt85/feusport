# frozen_string_literal: true

class Assessment < ApplicationRecord
  schema_validations
  belongs_to :competition
end
