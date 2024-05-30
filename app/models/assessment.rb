# frozen_string_literal: true

class Assessment < ApplicationRecord
  include SortableByName

  schema_validations
  belongs_to :competition
  belongs_to :discipline
  belongs_to :band

  delegate :like_fire_relay?, to: :discipline

  def name
    @name ||= forced_name.presence || [discipline&.name, band&.name].compact_blank.join(' - ')
  end

  def destroy_possible?
    true || results.empty?
  end

  def self.requestable_for_person(band)
    where(band:)
  end

  def self.requestable_for_team(band)
    where(band:).reject { |a| a.discipline.single_discipline? }
  end
end
