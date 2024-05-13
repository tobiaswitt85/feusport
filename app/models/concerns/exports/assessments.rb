# frozen_string_literal: true

module Exports::Assessments
  def index_export_data(collection)
    headline = [
      Assessment.human_attribute_name(:name),
      Assessment.human_attribute_name(:discipline),
      Assessment.human_attribute_name(:band),
    ]
    data = [headline]

    collection.each do |assessment|
      line = [
        assessment.decorated_name,
        assessment.discipline.name,
        assessment.band.name,
      ]
      data.push(line)
    end
    data
  end
end
