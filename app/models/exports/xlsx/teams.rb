# frozen_string_literal: true

Exports::Xlsx::Teams = Struct.new(:competition) do
  include Exports::Xlsx::Base
  include Exports::Teams

  def perform
    competition.bands.sort.each do |band|
      add_worksheet(band.name) do |sheet|
        index_export_data(band, full: true).each { |row| sheet.add_row(row) }
      end
    end
  end
end
