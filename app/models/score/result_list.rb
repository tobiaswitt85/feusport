# frozen_string_literal: true

class Score::ResultList < ApplicationRecord
  belongs_to :list, touch: true
  belongs_to :result
  schema_validations
end
