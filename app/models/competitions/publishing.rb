# frozen_string_literal: true

class Competitions::Publishing
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :competition, :user, :hint

  attribute :confirm, :boolean, default: false
  validates :confirm, acceptance: true
  validates :competition, :user, presence: true

  def save
    return false unless valid?

    Competition.transaction do
      competition.update!(locked_at: Time.current)
      FireSportStatistics::Publishing.create!(competition:, user:, hint:)
    end
  end
end
