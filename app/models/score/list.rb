# frozen_string_literal: true

class Score::List < ApplicationRecord
  belongs_to :competition

  schema_validations
end
