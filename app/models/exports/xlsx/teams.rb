# frozen_string_literal: true

Exports::Xlsx::Teams = Struct.new(:competition, :all_columns) do
  include Exports::Xlsx::Base
  include Exports::Teams

  def perform
    competition.bands.sort.each do |band|
      add_worksheet(band.name) do |sheet|
        index_export_data(band, full: true, all_columns:).each { |row| sheet.add_row(row) }
      end
    end
  end
end
