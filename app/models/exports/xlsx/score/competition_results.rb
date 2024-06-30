# frozen_string_literal: true

Exports::Xlsx::Score::CompetitionResults = Struct.new(:results) do
  include Exports::Xlsx::Base
  include Exports::CompetitionResults

  def perform
    results.each do |result|
      workbook.add_worksheet(name: result.short_name.truncate_bytes(30)) do |sheet|
        table_data(result).each { |row| sheet.add_row(row) }
      end
    end
  end

  def filename
    'gesamtwertungen.xlsx'
  end
end
