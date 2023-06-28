# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_authorization_check

  protected

  def after_sign_in_path_for(_user)
    before_url = session.delete(:requested_url_before_login)
    return before_url if before_url.present?

    super
  end
end
