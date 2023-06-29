# frozen_string_literal: true

module PageHelper
  def page_title(page_title, class: nil, competition: nil)
    @page_title = page_title
    hs = [tag.h1(page_title, class:)]
    if competition
      hs.push(tag.h2(competition.name))
      @page_title += " - #{competition.name}"
    end
    safe_join(hs)
  end
end
