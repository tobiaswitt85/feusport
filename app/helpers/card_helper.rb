# frozen_string_literal: true

module CardHelper
  def card(title = nil, options = {}, &block)
    card = Ui::CardBuilder.new(title, options, self, block)
    render('card', card:)
  end
end
