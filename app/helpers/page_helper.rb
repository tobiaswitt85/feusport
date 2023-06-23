# frozen_string_literal: true

module PageHelper
  def page_title(page_title)
    @page_title = page_title
    tag.h1(page_title)
  end
end
