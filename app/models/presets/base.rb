# frozen_string_literal: true

class Presets::Base
  Param = Struct.new(:name, :options)

  include ActiveModel::Model

  attr_accessor :competition

  validates :competition, presence: true

  def self.list
    {
      nothing: Presets::Nothing,
      fire_attack: Presets::FireAttack,
      single_disciplines: Presets::SingleDisciplines,
    }
  end

  def persisted?
    true
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      perform
      competition.update!(preset_ran: true)
    end
  end
end
