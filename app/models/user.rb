# frozen_string_literal: true

class User < ApplicationRecord
  include SortableByName

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :user_access_requests, class_name: 'UserAccessRequest', dependent: :destroy, foreign_key: :sender_id,
                                  inverse_of: :sender
  has_many :user_accesses, class_name: 'UserAccess', dependent: :destroy
  has_many :competitions, through: :user_accesses
  has_many :teams, class_name: 'Team', dependent: :nullify, foreign_key: :applicant_id, inverse_of: :applicant
  has_many :people, class_name: 'Person', dependent: :nullify, foreign_key: :applicant_id, inverse_of: :applicant

  auto_strip_attributes :name, :email, :phone_number

  schema_validations

  def friends
    User.where(id: UserAccess.where(competition_id: competition_ids).select(:user_id)).where.not(id:).order(:name)
  end

  def send_devise_notification(notification, *)
    devise_mailer.send(notification, self, *).deliver_later
  end
end
