# frozen_string_literal: true

Exports::Xlsx::People = Struct.new(:competition) do
  include Exports::Xlsx::Base
  include Exports::People

  def perform
    competition.bands.sort.each do |band|
      workbook.add_worksheet(name: band.name.truncate_bytes(30)) do |sheet|
        index_export_data(band).each { |row| sheet.add_row(row) }
      end
    end
  end
end
