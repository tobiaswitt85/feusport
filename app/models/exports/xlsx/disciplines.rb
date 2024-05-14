# frozen_string_literal: true

Exports::Xlsx::Disciplines = Struct.new(:competition) do
  include Exports::Xlsx::Base
  include Exports::Disciplines

  def perform
    workbook.add_worksheet(name: export_title.truncate_bytes(30)) do |sheet|
      index_export_data(competition.disciplines.sort).each { |row| sheet.add_row(row) }
    end
  end
end
