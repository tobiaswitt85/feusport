# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    global_abilities

    return if user.nil?

    can(:manage, Competition, user:)
    can(:manage, Document, competition: { user: })
    can(:manage, Discipline, competition: { user: })
  end

  def global_abilities
    can(:read, Competition, visible: true)
  end
end
