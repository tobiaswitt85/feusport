# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :competition
  belongs_to :band

  schema_validations
end
