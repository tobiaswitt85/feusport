# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    global_abilities

    return if user.nil?

    can(:manage, Competition, user:)
    can(:manage, Document, competition: { user: })
    can(:manage, Discipline, competition: { user: })
    can(:manage, Band, competition: { user: })
    can(:manage, Assessment, competition: { user: })
    can(:manage, Team, competition: { user: })
    can(:manage, Person, competition: { user: })
    can(:manage, Certificates::Template, competition: { user: })
    can(:manage, Score::List, competition: { user: })
    can(:manage, Score::ListEntry, competition: { user: })
    can(:manage, Score::Run, competition: { user: })
    can(:manage, Score::Result, competition: { user: })
    can(:manage, Score::ListFactory, competition: { user: })
  end

  def global_abilities
    can(:read, Competition, visible: true)
  end
end
