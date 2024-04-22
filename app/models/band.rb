# frozen_string_literal: true

class Band < ApplicationRecord
  schema_validations
  belongs_to :competition
end
