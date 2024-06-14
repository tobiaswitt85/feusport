# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :user_access_requests, class_name: 'UserAccessRequest', dependent: :destroy, foreign_key: :sender_id,
                                  inverse_of: :sender
  has_many :user_accesses, class_name: 'UserAccess', dependent: :destroy
  has_many :competitions, through: :user_accesses

  schema_validations

  def send_devise_notification(notification, *)
    devise_mailer.send(notification, self, *).deliver_later
  end
end
