# frozen_string_literal: true

class Score::List < ApplicationRecord
  belongs_to :competition
  has_many :list_assessments, dependent: :destroy
  has_many :assessments, through: :list_assessments
  has_many :result_lists, dependent: :destroy
  has_many :results, through: :result_lists
  has_many :entries, -> { order(:run).order(:track) }, class_name: 'Score::ListEntry', dependent: :destroy,
                                                       inverse_of: :list

  default_scope { order(:name) }

  schema_validations
  validates :track_count, numericality: { greater_than: 0 }
  accepts_nested_attributes_for :entries, allow_destroy: true

  def next_free_track
    last_entry = entries.last
    run = last_entry.try(:run) || 1
    track = last_entry.try(:track) || 0
    track += 1
    if track > track_count
      track = 1
      run += 1
    end
    [run, track]
  end

  def discipline
    assessments.first.discipline
  end

  def single_discipline?
    @single_discipline ||= assessments.first.discipline.single_discipline?
  end

  def multiple_assessments?
    @multiple_assessments ||= assessments.count > 1
  end

  def discipline_klass
    if single_discipline?
      Person
    elsif assessments.first.fire_relay?
      TeamRelay
    else
      Team
    end
  end
end
