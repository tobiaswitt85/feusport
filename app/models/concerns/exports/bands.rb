# frozen_string_literal: true

module Exports::Bands
  def index_export_data(collection)
    headline = [
      Band.human_attribute_name(:name),
      Band.human_attribute_name(:gender),
      Band.human_attribute_name(:assessments),
    ]
    data = [headline]

    collection.each do |band|
      line = [
        band.name,
        band.translated_gender,
        band.assessments.count,
      ]
      data.push(line)
    end
    data
  end

  def export_title
    @export_title ||= Band.model_name.human(count: :many)
  end
end
