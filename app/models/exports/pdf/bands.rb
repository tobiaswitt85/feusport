# frozen_string_literal: true

Exports::Pdf::Bands = Struct.new(:competition) do
  include Exports::Pdf::Base
  include Exports::Bands

  def perform
    pdf_header(export_title)
    pdf.table(index_export_data(competition.bands.sort),
              header: true,
              row_colors: pdf_default_row_colors,
              width: pdf.bounds.width) do
      row(0).style(align: :center, font_style: :bold)
      column(1).style(align: :center)
      column(2).style(align: :center)
    end

    pdf_footer(name: export_title)
  end
end
