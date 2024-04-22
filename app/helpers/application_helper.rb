# frozen_string_literal: true

module ApplicationHelper
  def qrcode(url)
    RQRCode::QRCode.new(url).as_png(size: 200, fill: ChunkyPNG::Color::TRANSPARENT).to_data_url
  end

  def competition_nested?
    controller.is_a?(CompetitionNestedController) && @competition.present?
  end

  def competition_path(competition)
    competition_show_path(competition.year, competition.slug)
  end
end
