# frozen_string_literal: true

require 'net/http'
require 'json'

class ImportSuggestionsJob < ApplicationJob
  def perform
    ActiveRecord::Base.transaction do
      destroy_old_imports
      import_people
      import_teams
      import_team_members
      import_team_spellings
      import_person_spellings
    end
  end

  protected

  def import_people
    fetch(:people, extended: 1) do |person|
      people[person[:id].to_i] = FireSportStatistics::Person.create!(
        id: person[:id],
        last_name: person[:last_name],
        first_name: person[:first_name],
        gender: person[:gender],
        personal_best_hb: person[:best_scores].dig('pb', 'hb', 0),
        personal_best_hb_competition: person[:best_scores].dig('pb', 'hb', 1),
        personal_best_hl: person[:best_scores].dig('pb', 'hl', 0),
        personal_best_hl_competition: person[:best_scores].dig('pb', 'hl', 1),
        personal_best_zk: person[:best_scores].dig('pb', 'zk', 0),
        personal_best_zk_competition: person[:best_scores].dig('pb', 'zk', 1),
        saison_best_hb: person[:best_scores].dig('sb', 'hb', 0),
        saison_best_hb_competition: person[:best_scores].dig('sb', 'hb', 1),
        saison_best_hl: person[:best_scores].dig('sb', 'hl', 0),
        saison_best_hl_competition: person[:best_scores].dig('sb', 'hl', 1),
        saison_best_zk: person[:best_scores].dig('sb', 'zk', 0),
        saison_best_zk_competition: person[:best_scores].dig('sb', 'zk', 1),
      )
    end
  end

  def import_teams
    fetch(:teams) do |team|
      teams[team[:id].to_i] = FireSportStatistics::Team.create!(
        id: team[:id],
        name: team[:name],
        short: team[:shortcut],
      )
    end
  end

  def import_team_members
    fetch(:team_members) do |association|
      FireSportStatistics::TeamAssociation.create!(
        person: people[association[:person_id].to_i],
        team: teams[association[:team_id].to_i],
      )
    end
  end

  def import_team_spellings
    fetch(:team_spellings) do |spelling|
      FireSportStatistics::TeamSpelling.create!(
        team: teams[spelling[:team_id].to_i],
        name: spelling[:name],
        short: spelling[:shortcut],
      )
    end
  end

  def import_person_spellings
    fetch(:person_spellings) do |spelling|
      FireSportStatistics::PersonSpelling.create!(
        person: people[spelling[:person_id].to_i],
        last_name: spelling[:last_name],
        first_name: spelling[:first_name],
        gender: spelling[:gender],
      )
    end
  end

  def people
    @people ||= []
  end

  def teams
    @teams ||= []
  end

  def destroy_old_imports
    FireSportStatistics::TeamAssociation.delete_all
    FireSportStatistics::TeamSpelling.delete_all
    FireSportStatistics::PersonSpelling.delete_all
    FireSportStatistics::Team.delete_all
    FireSportStatistics::Person.delete_all
  end

  def fetch(type, params = nil)
    json_object = handle_response(conn.get("/api/#{type}?#{params&.to_query}"))

    json_object.fetch(type.to_s.tr('/', '_')).each do |entry|
      yield(entry.with_indifferent_access)
    end
  end

  def handle_response(response)
    JSON.parse(response.body)
  end

  def conn
    @conn ||= begin
      http = Net::HTTP.new('feuerwehrsport-statistik.de', 443)
      http.use_ssl = true
      http
    end
  end
end
