# frozen_string_literal: true

class FireSportStatistics::TeamSpelling < ApplicationRecord
  include FireSportStatistics::TeamScopes
  belongs_to :team

  auto_strip_attributes :name, :short
  schema_validations
end
