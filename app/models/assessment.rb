# frozen_string_literal: true

class Assessment < ApplicationRecord
  include SortableByName

  attribute :generate_score_result, :boolean, default: false

  belongs_to :competition
  belongs_to :discipline
  belongs_to :band
  has_many :requests, class_name: 'AssessmentRequest', dependent: :destroy, inverse_of: :assessment
  has_many :results, class_name: 'Score::Result', dependent: :restrict_with_error, inverse_of: :assessment
  has_many :list_assessments, class_name: 'Score::ListAssessment', dependent: :restrict_with_error,
                              inverse_of: :assessment
  has_many :lists, class_name: 'Score::List', through: :list_assessments, dependent: :restrict_with_error

  scope :no_zweikampf, -> { joins(:discipline).where.not(disciplines: { key: 'zk' }) }
  scope :single_disciplines, -> { joins(:discipline).where(disciplines: { single_discipline: true }) }

  schema_validations
  delegate :like_fire_relay?, to: :discipline

  after_create do
    competition.score_results.create!(assessment: self) if generate_score_result
  end

  def name
    @name ||= forced_name.presence || [discipline&.name, band&.name].compact_blank.join(' - ')
  end
  alias to_label name

  def destroy_possible?
    true || results.empty?
  end

  def self.requestable_for_person(band)
    where(band:)
  end

  def self.requestable_for_team(band)
    where(band:).reject { |a| a.discipline.single_discipline? }
  end

  def name_with_request_count
    if like_fire_relay? && related_requests.present?
      numbers = []
      (1..related_requests.map(&:relay_count).max).each do |number|
        count = related_requests.where('relay_count >= ?', number).count
        numbers.push("#{count}x #{(64 + number).chr}")
      end
      "#{to_label} (#{numbers.join(', ')})"
    else
      "#{to_label} (#{related_requests.count} Starter)"
    end
  end

  def related_requests
    if discipline.single_discipline?
      requests.where(entity_type: 'Person')
    else
      requests.where(entity_type: 'Team')
    end
  end
end
