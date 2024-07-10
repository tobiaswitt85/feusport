# frozen_string_literal: true

class Band < ApplicationRecord
  include SortableByName

  GENDERS = { female: 0, male: 1, indifferent: 2 }.freeze

  enum gender: GENDERS
  default_scope { order(:position) }

  belongs_to :competition, touch: true
  has_many :assessments, class_name: 'Assessment', dependent: :restrict_with_error
  has_many :teams, dependent: :restrict_with_error
  has_many :people, dependent: :restrict_with_error
  has_many :score_list_factory_bands, class_name: 'Score::ListFactoryBand', dependent: :destroy
  has_many :score_list_factories, class_name: 'Score::ListFactory', through: :score_list_factory_bands,
                                  source: :list_factory

  acts_as_list

  schema_validations

  after_save :clean_tags

  def <=>(other)
    sort_by_position = position <=> other.position
    return sort_by_position unless sort_by_position == 0

    super
  end

  def translated_gender
    gender.present? ? I18n.t("gender.#{gender}") : ''
  end

  def destroy_possible?
    assessments.empty?
  end

  def person_tag_names=(names)
    self.person_tags = names.to_s.split(',').map(&:strip).compact_blank.sort
  end

  def person_tag_names
    (person_tags || []).sort.join(', ')
  end

  def team_tag_names=(names)
    self.team_tags = names.to_s.split(',').map(&:strip).compact_blank.sort
  end

  def team_tag_names
    (team_tags || []).sort.join(', ')
  end

  private

  def clean_tags
    people.each(&:save!) if saved_change_to_attribute?(:person_tags)
    teams.each(&:save!) if saved_change_to_attribute?(:team_tags)

    return unless saved_change_to_attribute?(:team_tags) || saved_change_to_attribute?(:person_tags)

    assessments.each { |assessment| assessment.results.each(&:save!) }
  end
end
