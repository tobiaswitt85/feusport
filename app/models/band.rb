# frozen_string_literal: true

class Band < ApplicationRecord
  include SortableByName

  GENDERS = { female: 0, male: 1, indifferent: 2 }.freeze
  GENDER_KEYS = GENDERS.keys.freeze

  enum gender: GENDERS
  scope :gender, ->(gender) { where(gender: GENDERS[gender.to_sym]) }
  default_scope { order(:position) }

  belongs_to :competition
  has_many :assessments, class_name: 'Assessment', dependent: :restrict_with_error
  has_many :teams, dependent: :restrict_with_error
  has_many :people, dependent: :restrict_with_error
  # TODO: has_and_belongs_to_many :score_list_factories, class_name: 'Score::ListFactory'

  acts_as_list

  schema_validations

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
    self.person_tags = names.to_s.split(',').map(&:strip).compact_blank
  end

  def person_tag_names
    (person_tags || []).sort.join(', ')
  end

  def team_tag_names=(names)
    self.team_tags = names.to_s.split(',').map(&:strip).compact_blank
  end

  def team_tag_names
    (team_tags || []).sort.join(', ')
  end
end
