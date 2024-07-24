# frozen_string_literal: true

class FireSportStatistics::PersonSpelling < ApplicationRecord
  include Genderable

  belongs_to :person, class_name: 'FireSportStatistics::Person', inverse_of: :spellings

  auto_strip_attributes :first_name, :last_name

  schema_validations
end
