# frozen_string_literal: true

module PageHelper
  def page_title(page_title, class: nil)
    @page_title = page_title

    @page_title += " - #{@competition.name} - #{l(@competition.date)}" if competition_nested?

    tag.h1(page_title, class:)
  end
end
