# frozen_string_literal: true

class Score::ResultList < ApplicationRecord
  belongs_to :list
  belongs_to :result
  schema_validations
end
