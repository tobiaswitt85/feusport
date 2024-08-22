# frozen_string_literal: true

Exports::Xlsx::Assessments = Struct.new(:competition) do
  include Exports::Xlsx::Base
  include Exports::Assessments

  def perform
    add_worksheet(export_title) do |sheet|
      index_export_data(competition.assessments.sort).each { |row| sheet.add_row(row) }
    end
  end
end
