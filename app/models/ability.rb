# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, simple_access: nil)
    global_abilities

    simple_access_abilities(simple_access) if simple_access.present?
    return if user.nil?

    can(:visit, :disseminator)

    can(:connect, UserAccessRequest)

    can(:manage, Competition, user_accesses: { user_id: user.id })
    can(:manage, Document, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Discipline, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Band, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Assessment, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Team, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Person, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Certificates::Template, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Score::List, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Score::ListEntry, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Score::Run, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Score::Result, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Score::CompetitionResult, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Score::ListFactory, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Score::ListPrintGenerator, competition: { user_accesses: { user_id: user.id } })
    can(:manage, SimpleAccess, competition: { user_accesses: { user_id: user.id } })
    can(:manage, UserAccess, competition: { user_accesses: { user_id: user.id } })
    can(:manage, UserAccessRequest, competition: { user_accesses: { user_id: user.id } })
    can(:manage, Presets::Base) { |preset| can?(:manage, preset.competition) }

    can(%i[create], Team) { |team| team.competition.registration_possible? }
    can(%i[edit_assessment_requests update destroy], Team) do |team|
      team.applicant == user && team.competition.registration_possible?
    end

    can(%i[create], Person) do |person|
      (person.team.nil? || person.team.applicant == user) &&
        person.competition.registration_possible?
    end
    can(%i[edit_assessment_requests update destroy], Person) do |person|
      (person.applicant == user || person.team&.applicant == user) &&
        person.competition.registration_possible?
    end
  end

  def global_abilities
    can(:read, Competition, visible: true)
    can(:read, Document, competition: { visible: true })
    can(:read, Discipline, competition: { visible: true })
    can(:read, Band, competition: { visible: true })
    can(:read, Assessment, competition: { visible: true })
    can(:read, Team, competition: { visible: true })
    can(:read, Person, competition: { visible: true })
    can(:read, Score::List, competition: { visible: true })
    can(:read, Score::Result, competition: { visible: true })
    can(:read, Score::CompetitionResult, competition: { visible: true })
  end

  def simple_access_abilities(simple_access)
    can(:manage, Competition, id: simple_access.competition_id)
    can(:manage, Document, competition: { id: simple_access.competition_id })
    can(:manage, Discipline, competition: { id: simple_access.competition_id })
    can(:manage, Band, competition: { id: simple_access.competition_id })
    can(:manage, Assessment, competition: { id: simple_access.competition_id })
    can(:manage, Team, competition: { id: simple_access.competition_id })
    can(:manage, Person, competition: { id: simple_access.competition_id })
    can(:manage, Certificates::Template, competition: { id: simple_access.competition_id })
    can(:manage, Score::List, competition: { id: simple_access.competition_id })
    can(:manage, Score::ListEntry, competition: { id: simple_access.competition_id })
    can(:manage, Score::Run, competition: { id: simple_access.competition_id })
    can(:manage, Score::Result, competition: { id: simple_access.competition_id })
    can(:manage, Score::CompetitionResult, competition: { id: simple_access.competition_id })
    can(:manage, Score::ListFactory, competition: { id: simple_access.competition_id })
    can(:manage, Score::ListPrintGenerator, competition: { id: simple_access.competition_id })
    can(:manage, Presets::Base) { |preset| can?(:manage, preset.competition) }
  end
end
