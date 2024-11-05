# frozen_string_literal: true

module LinkHelper
  def btn_link_to(label, url, options = {})
    options[:class] ||= ''
    options[:class] += ' btn btn-light btn-sm'
    options[:class] += ' disabled' if options[:disabled]

    link_to(label, url, options)
  end

  def block_link_to(label, url, options = {})
    options[:class] ||= ''
    options[:class] += ' btn-block'
    btn_link_to(label, url, options)
  end
end
