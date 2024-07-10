# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  def mail(*)
    attachments.inline['logo.png'] = {
      mime_type: 'image/png',
      content: Rails.root.join('app/assets/images/logo.png').read,
    }
    super
  end

  protected

  def default_url_options
    Rails.application.config.default_url_options
  end
end
