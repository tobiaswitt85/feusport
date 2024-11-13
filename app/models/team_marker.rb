# frozen_string_literal: true

class TeamMarker < ApplicationRecord
  include SortableByName
  VALUE_TYPES = { boolean: 0, date: 1, string: 2 }.freeze
  enum :value_type, VALUE_TYPES, scopes: false, default: :boolean, prefix: true

  belongs_to :competition

  schema_validations

  def self.create_example(competition)
    create(competition:, name: 'Angereist?', value_type: :boolean)
  end
end
