# frozen_string_literal: true

module Exports::Base
  extend ActiveSupport::Concern

  included do
    delegate :t, :l, to: I18n
  end

  def filename_base
    export_title.underscore.dasherize
  end
end
