# frozen_string_literal: true

class Discipline < ApplicationRecord
  include SortableByName

  DISCIPLINES = %w[la hl hb zk gs fs other].freeze
  DEFAULT_NAMES = {
    la: 'Löschangriff Nass',
    hl: 'Hakenleitersteigen',
    hb: '100m-Hindernisbahn',
    zk: 'Zweikampf',
    gs: 'Gruppenstafette',
    fs: '4x100m-Hindernisstaffel',
    other: 'Andere',
  }.with_indifferent_access.freeze
  DEFAULT_SINGLE_DISCIPLINES = {
    la: false,
    hl: true,
    hb: true,
    zk: true,
    gs: false,
    fs: false,
    other: false,
  }.with_indifferent_access.freeze

  belongs_to :competition, touch: true
  has_many :assessments, dependent: :restrict_with_error

  scope :single_disciplines, -> { where(single_discipline: true) }
  auto_strip_attributes :name, :short_name

  schema_validations
  validates :key, inclusion: { in: DISCIPLINES }, allow_blank: true

  def destroy_possible?
    assessments.empty?
  end

  def zweikampf?
    key == 'zk'
  end
end
