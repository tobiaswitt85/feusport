# frozen_string_literal: true

class FireSportStatistics::PersonSpelling < ApplicationRecord
  include Genderable

  belongs_to :person, class_name: 'FireSportStatistics::Person', inverse_of: :spellings

  schema_validations exclude: [:gender]
end
