# frozen_string_literal: true

module CardHelper
  def card(headline = nil, options = {}, &block)
    card = Ui::CardBuilder.new(headline, options, self, block)
    render('card', card:)
  end

  def card_body(headline = nil, options = {}, &block)
    card(headline, options) { |c| c.body(&block) }
  end

  def card_direct(headline = nil, options = {}, &block)
    card(headline, options) { |c| c.direct(&block) }
  end
end
