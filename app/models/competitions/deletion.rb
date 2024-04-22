# frozen_string_literal: true

class Competitions::Deletion
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :competition

  attribute :confirm, :boolean, default: false
  validates :confirm, acceptance: true

  def save
    return false unless valid?

    competition.destroy
  end
end
