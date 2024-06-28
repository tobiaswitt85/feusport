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

  def short_edit_link(path, options = {})
    options[:title] ||= 'Bearbeiten'
    icon_link_btn('far fa-edit', path, options)
  end

  def short_destroy_link(path, options = {})
    options[:title] ||= 'Löschen'
    icon_link_btn('far fa-trash', path, options)
  end

  def icon_link_btn(icon_classes, path, options = {})
    btn_link_to(tag.i('', class: icon_classes), path, options)
  end

  def personal_best_badge(person, current_result = nil)
    return if person.nil?

    classes = %w[balloon best-badge]
    classes.push('personal-best') if person.new_personal_best?(current_result)
    tag.span('i', class: classes, data: { balloon_content: render('competitions/people/best_badge', person:) })
  end

  def person_short_type(request)
    if request.group_competitor?
      I18n.t('assessment_types.group_competitor_short_order',
             competitor_order: request.group_competitor_order)
    elsif request.single_competitor?
      I18n.t('assessment_types.single_competitor_short_order',
             competitor_order: request.single_competitor_order)
    elsif request.out_of_competition?
      I18n.t('assessment_types.out_of_competition_short')
    elsif request.competitor?
      case request.assessment.discipline.key
      when 'fs'
        AssessmentRequest.fs_names[competitor_order]
      when 'la', 'gs'
        arr = AssessmentRequest.short_names[request.assessment.discipline.key][request.competitor_order] || []
        arr[1] = tag.span(arr[1], class: 'small') if arr[1]
        safe_join(arr)
      end
    else
      0
    end
  end
end
