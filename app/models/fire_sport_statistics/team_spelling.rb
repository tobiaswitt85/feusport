# frozen_string_literal: true

class FireSportStatistics::TeamSpelling < ApplicationRecord
  include FireSportStatistics::TeamScopes
  belongs_to :team

  schema_validations
end
