# frozen_string_literal: true

Exports::Xlsx::Assessments = Struct.new(:competition) do
  include Exports::Xlsx::Base
  include Exports::Assessments

  def perform
    workbook.add_worksheet(name: Assessment.model_name.human(count: :many).truncate_bytes(30)) do |sheet|
      index_export_data(competition.assessments.sort).each { |row| sheet.add_row(row) }
    end
  end

  def filename
    'wertungen.xlsx'
  end
end
