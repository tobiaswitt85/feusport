# frozen_string_literal: true

module ApplicationHelper
  SOCIAL_SHARE_SITES = %i[twitter facebook email vkontakte telegram whatsapp_app whatsapp_web].freeze
  def qrcode(url)
    RQRCode::QRCode.new(url).as_png(size: 200, fill: ChunkyPNG::Color::TRANSPARENT).to_data_url
  end

  def competition_nested?
    controller.is_a?(CompetitionNestedController) && @competition.present?
  end

  def competition_path(competition)
    competition_show_path(competition.year, competition.slug)
  end

  def social_share_button_tag(_title = '', _opts = {})
    links = SOCIAL_SHARE_SITES.map do |name|
      link_title = t('social_share_button.share_to', name: t("social_share_button.#{name}"))
      link_to('', '#', rel: 'nofollow',
                       'data-site' => name,
                       :class => "ssb-icon ssb-#{name}",
                       :onclick => 'return SocialShareButton.share(this);',
                       :title => h(link_title))
    end
    tag.div(safe_join(links, ' '), class: 'social-share-button')
  end

  def discipline_image(discipline, options = {})
    options[:size] ||= '20x20'
    image_tag "disciplines/#{discipline}.svg", options
  end
end
