# frozen_string_literal: true

module CardHelper
  def card(headline = nil, options = {}, &block)
    title = options.delete(:title)
    page_title(headline) if title

    card = Ui::CardBuilder.new(headline, options, self, block)
    render('card', card:)
  end
end
