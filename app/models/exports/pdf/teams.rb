# frozen_string_literal: true

Exports::Pdf::Teams = Struct.new(:competition) do
  include Exports::Pdf::Base
  include Exports::Teams

  def perform
    competition.bands.sort.each_with_index do |band, index|
      pdf.start_new_page unless index.zero?

      pdf.font_size = 10
      pdf_header("#{Team.model_name.human(count: :many)} - #{band.name}")
      pdf.table(index_export_data(band),
                header: true,
                row_colors: pdf_default_row_colors,
                cell_style: { align: :center },
                width: pdf.bounds.width) do
        row(0).style(font_style: :bold)
      end
    end
    pdf_footer(name: export_title)
  end

  protected

  def default_prawn_options
    super.merge(page_layout: :landscape)
  end
end
