# frozen_string_literal: true

module ExportsSupport
  extend ActiveSupport::Concern

  protected

  def send_pdf(klass, filename: nil, args: [], format: :pdf, &)
    send_attachment(klass, filename:, args:, format:, type: :pdf, &)
  end

  def send_xlsx(klass, filename: nil, args: [], format: :xlsx, &)
    send_attachment(klass, filename:, args:, format:, type: :xlsx, &)
  end

  def send_attachment(klass, format:, type:, filename: nil, args: [])
    return if format.present? && request.format.to_sym != format

    args = yield if block_given?
    model = klass.perform(*args)
    filename ||= model.filename if model.respond_to?(:filename)
    filename ||= "#{@page_title.parameterize}.#{type}" if @page_title.present?
    options = { type: Mime[type], disposition: (type == :pdf ? 'inline' : 'attachment') }
    send_data(model.bytestream, options.merge(filename:))
  end
end
