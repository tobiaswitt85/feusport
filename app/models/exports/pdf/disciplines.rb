# frozen_string_literal: true

Exports::Pdf::Disciplines = Struct.new(:competition) do
  include Exports::Pdf::Base
  include Exports::Disciplines

  def perform
    lines = index_export_data(competition.disciplines.sort)
    lines.each_with_index do |line, i|
      next if i == 0

      line[2] = line[2] ? 'Ja' : 'Nein'
      line[3] = line[3] ? 'Ja' : 'Nein'
    end
    pdf_header(export_title)
    pdf.table(lines,
              header: true,
              row_colors: pdf_default_row_colors,
              width: pdf.bounds.width) do
      row(0).style(align: :center, font_style: :bold)
      column(1).style(align: :center)
      column(2).style(align: :center)
      column(3).style(align: :center)
      column(4).style(align: :center)
    end

    pdf_footer(name: export_title)
  end
end
