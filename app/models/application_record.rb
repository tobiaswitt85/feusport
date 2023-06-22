# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include SchemaValidations # to include auto generated validations
end
