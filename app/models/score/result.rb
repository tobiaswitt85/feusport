# frozen_string_literal: true

class Score::Result < ApplicationRecord
  include Score::Resultable
  include SortableByName

  CALCULATION_METHODS = { default: 0, sum_of_two: 1 }.freeze

  enum calculation_method: CALCULATION_METHODS

  belongs_to :competition, touch: true
  belongs_to :assessment, inverse_of: :results
  belongs_to :double_event_result, dependent: :destroy, class_name: 'Score::DoubleEventResult', inverse_of: :results
  has_many :result_lists, dependent: :destroy, inverse_of: :result
  has_many :lists, through: :result_lists
  has_many :result_series_assessments, class_name: 'Score::ResultSeriesAssessment', dependent: :destroy,
                                       inverse_of: :result
  has_many :series_assessments, through: :result_series_assessments, source: :assessment,
                                class_name: 'Series::Assessment'
  has_many :competition_result_references, class_name: 'Score::CompetitionResultReference', dependent: :destroy
  has_many :competition_results, class_name: 'Score::CompetitionResult', through: :competition_result_references

  delegate :discipline, to: :assessment
  delegate :band, to: :assessment, allow_nil: true

  scope :gender, ->(gender) { joins(:assessment).merge(Assessment.gender(gender)) }
  scope :group_assessment_for, ->(gender) { gender(gender).where(group_assessment: true) }
  scope :discipline, ->(discipline) { where(assessment: Assessment.discipline(discipline)) }
  scope :no_zweikampf, -> { where.not(type: 'Score::DoubleEventResult') }

  schema_validations
  before_validation :clean_tags
  validate :useless_team_tags
  validate :useless_person_tags
  validates :group_run_count, :group_score_count, numericality: { greater_than: 0 }
  validates :assessment, :double_event_result, :competition_results, same_competition: true

  def name
    @name ||= forced_name.presence || generated_name
  end
  alias to_label name

  def generated_name
    tags_included = (team_tags_included + person_tags_included).join(', ').presence
    tags_excluded = (team_tags_excluded + person_tags_excluded).join(', ').presence
    tags_excluded = "ohne #{tags_excluded}" if tags_excluded.present?
    [assessment.name, tags_included, tags_excluded].compact_blank.join(' - ')
  end

  def possible_series_assessments
    Series::Assessment.gender(assessment.band.gender)
                      .where(discipline: assessment.discipline.key)
                      .year(Date.current.year)
  end

  def single_group_result?
    group_assessment? && discipline.single_discipline?
  end

  def rows
    @rows ||= generate_rows.sort
  end

  def out_of_competition_rows
    generate_rows if @out_of_competition_rows.nil?
    @out_of_competition_rows
  end

  def group_result_rows
    @group_result_rows ||= generate_rows(group_result: true).sort
  end

  def person_tags
    @person_tags ||= tags.where(type: 'PersonTag')
  end

  def team_tags
    @team_tags ||= tags.where(type: 'TeamTag')
  end

  def generate_rows(group_result: false)
    out_of_competition_rows = {}
    rows = {}
    lists.each do |list|
      list.entries.not_waiting.each do |list_entry|
        next if list_entry.assessment != assessment

        entity = list_entry.entity
        entity = entity.team if group_result && entity.is_a?(TeamRelay)
        next unless use?(entity)

        if list_entry.out_of_competition?
          if out_of_competition_rows[entity.id].nil?
            out_of_competition_rows[entity.id] = Score::ResultRow.new(entity, self)
          end
          out_of_competition_rows[entity.id].add_list(list_entry)
        else
          rows[entity.id] = Score::ResultRow.new(entity, self) if rows[entity.id].nil?
          rows[entity.id].add_list(list_entry)
        end
      end
    end
    @out_of_competition_rows = out_of_competition_rows.values
    rows.values
  end

  def group_result
    @group_result ||= Score::GroupResult.new(self)
  end

  protected

  def use?(entity)
    case entity
    when TeamRelay
      entity.team.include_tags?(team_tags_included) && entity.team.exclude_tags?(team_tags_excluded)
    when Team
      entity.include_tags?(team_tags_included) && entity.exclude_tags?(team_tags_excluded)
    when Person
      entity.include_tags?(person_tags_included) && entity.exclude_tags?(person_tags_excluded) &&
        (team_tags_included.blank? || entity.team&.include_tags?(team_tags_included)) &&
        (team_tags_excluded.blank? || entity.team&.exclude_tags?(team_tags_excluded))
    else
      false
    end
  end

  def clean_tags
    self.team_tags_included = (team_tags_included || []).select { |tag| tag.in?(band.team_tags) }
    self.team_tags_excluded = (team_tags_excluded || []).select { |tag| tag.in?(band.team_tags) }
    self.person_tags_included = (person_tags_included || []).select { |tag| tag.in?(band.person_tags) }
    self.person_tags_excluded = (person_tags_excluded || []).select { |tag| tag.in?(band.person_tags) }
  end

  def useless_team_tags
    return unless team_tags_included.any? { |tag| tag.in?(team_tags_excluded) }

    errors.add(:team_tags_included, :invalid)
    errors.add(:team_tags_excluded, :invalid)
  end

  def useless_person_tags
    return unless person_tags_included.any? { |tag| tag.in?(person_tags_excluded) }

    errors.add(:person_tags_included, :invalid)
    errors.add(:person_tags_excluded, :invalid)
  end
end
