# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :competition
  schema_validations
end
