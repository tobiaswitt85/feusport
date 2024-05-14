# frozen_string_literal: true

module Exports::Disciplines
  def index_export_data(collection)
    headline = [
      Discipline.human_attribute_name(:name),
      Discipline.human_attribute_name(:short_name),
      'Einzel',
      'Staffel',
      Discipline.human_attribute_name(:assessments),
    ]
    data = [headline]

    collection.each do |discipline|
      line = [
        discipline.name,
        discipline.short_name,
        discipline.single_discipline,
        discipline.like_fire_relay,
        discipline.assessments.count,
      ]
      data.push(line)
    end
    data
  end

  def export_title
    @export_title ||= Discipline.model_name.human(count: :many)
  end
end
