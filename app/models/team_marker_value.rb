# frozen_string_literal: true

class TeamMarkerValue < ApplicationRecord
  belongs_to :team_marker
  belongs_to :team

  delegate :competition, :name, :value_type_boolean?, :value_type_date?, :value_type_string?, to: :team_marker

  schema_validations
  validates :team, same_competition: true

  def value
    return I18n.t('a.yes') if value_type_boolean? && boolean_value?
    return I18n.t('a.no') if value_type_boolean? && !boolean_value?
    return I18n.l(date_value) if value_type_date? && date_value.present?

    string_value if value_type_string?
  end

  def value_present?
    return true if value_type_boolean? && boolean_value?
    return true if value_type_date? && date_value.present?
    return true if value_type_string? && string_value.present?

    false
  end
end
