# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  protected

  def default_url_options
    Rails.application.config.default_url_options
  end
end
