# frozen_string_literal: true

class Discipline < ApplicationRecord
  DISCIPLINES = %w[la hl hb zk gs fs other].freeze

  belongs_to :competition
  has_many :assessments, dependent: :restrict_with_error

  schema_validations
  validates :key, inclusion: { in: DISCIPLINES }

  def destroy_possible?
    assessments.empty?
  end
end
