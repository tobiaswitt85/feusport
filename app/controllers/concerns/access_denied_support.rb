# frozen_string_literal: true

module AccessDeniedSupport
  extend ActiveSupport::Concern
  included do
    rescue_from CanCan::AccessDenied do |exception|
      if Rails.env.development?
        # :nocov:
        Rails.logger.warn '### Access Denied'
        Rails.logger.warn exception.inspect
        # :nocov:
      end
      if current_user
        flash[:alert] = 'Zugriff verweigert'
        redirect_to root_path
      else
        flash[:alert] = 'Bitte melden Sie sich an'
        session[:requested_url_before_login] = request.fullpath if request.format == :html
        redirect_to new_user_session_path
      end
    end
  end
end
