# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    global_abilities

    return if user.nil?

    can(:manage, Competition)
    can(:manage, Document)
  end

  def global_abilities
    can(:read, Competition, visible: true)
  end
end
