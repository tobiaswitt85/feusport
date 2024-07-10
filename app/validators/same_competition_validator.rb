# frozen_string_literal: true

class SameCompetitionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return if values.nil?

    values = [values] if values.respond_to?(:competition) && !values.is_a?(Enumerable)

    values.each do |value|
      next if value.nil?
      next if value.competition.nil?
      next if record.competition.nil?
      next if value.competition == record.competition

      record.errors.add(attribute, :not_same_competition)
    end
  end
end
