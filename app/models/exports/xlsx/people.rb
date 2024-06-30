# frozen_string_literal: true

Exports::Xlsx::People = Struct.new(:people) do
  include Exports::Xlsx::Base
  include Exports::People

  def perform
    Band.find_each do |band|
      people_table(band, people.where(band:).decorate)
    end
  end

  def filename
    'wettkaempfer.xlsx'
  end

  protected

  def people_table(band, rows)
    return if rows.blank?

    workbook.add_worksheet(name: band.name.truncate_bytes(30)) do |sheet|
      index_export_data(band, rows).each { |row| sheet.add_row(row) }
    end
  end
end
