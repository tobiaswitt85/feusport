# frozen_string_literal: true

class UserAccessRequest < ApplicationRecord
  belongs_to :competition, touch: true
  belongs_to :sender, class_name: 'User'

  schema_validations
  validates :email, 'valid_email_2/email': Rails.configuration.x.email_validation

  def connect(user)
    competition.user_accesses.create!(user:)
    competition.user_accesses.where(user: sender).destroy_all if drop_myself?
    destroy
  end
end
