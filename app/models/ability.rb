# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    global_abilities

    return if user.nil?

    can(:connect, UserAccessRequest)

    can(:manage, Competition, user_accesses: { user: })
    can(:manage, Document, competition: { user_accesses: { user: } })
    can(:manage, Discipline, competition: { user_accesses: { user: } })
    can(:manage, Band, competition: { user_accesses: { user: } })
    can(:manage, Assessment, competition: { user_accesses: { user: } })
    can(:manage, Team, competition: { user_accesses: { user: } })
    can(:manage, Person, competition: { user_accesses: { user: } })
    can(:manage, Certificates::Template, competition: { user_accesses: { user: } })
    can(:manage, Score::List, competition: { user_accesses: { user: } })
    can(:manage, Score::ListEntry, competition: { user_accesses: { user: } })
    can(:manage, Score::Run, competition: { user_accesses: { user: } })
    can(:manage, Score::Result, competition: { user_accesses: { user: } })
    can(:manage, Score::CompetitionResult, competition: { user_accesses: { user: } })
    can(:manage, Score::ListFactory, competition: { user_accesses: { user: } })
    can(:manage, UserAccess, competition: { user_accesses: { user_id: user.id } })
    can(:manage, UserAccessRequest, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Presets::Base) { |preset| can?(:manage, preset.competition) }
  end

  def global_abilities
    can(:read, Competition, visible: true)
  end
end
