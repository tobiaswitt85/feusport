# frozen_string_literal: true

class WettkampfManagerImport
  attr_reader :db, :competition

  def initialize(db_path)
    @db = SQLite3::Database.open(db_path)

    name, date, place = @db.execute('SELECT name,date,place FROM competitions').first
    @competition = Competition.create_with(user: User.first).find_or_create_by!(
      name:, locality: place, visible: true, date:,
    )

    competition.score_lists.destroy_all
    competition.teams.destroy_all
    competition.score_results.destroy_all
    competition.assessments.destroy_all
    competition.disciplines.destroy_all
    competition.bands.destroy_all

    load_bands
    load_disciplines
    load_assessments
    load_score_results
    load_teams
    load_assessment_requests
    load_score_lists
    load_score_list_entries
  end

  def load_bands
    @bands_translations = {}
    @db.execute('SELECT id,gender,name,position FROM bands ORDER BY position').each do |id, gender, name, position|
      band = competition.bands.create!(gender:, name:, position:)
      @bands_translations[id] = band.id
    end
  end

  def load_disciplines
    @disciplines_translations = {}
    @db.execute('SELECT id,name,type,short_name,like_fire_relay FROM disciplines')
       .each do |id, name, type, short_name, like_fire_relay|
      case type
      when 'Disciplines::FireAttack'
        name = name.presence || Discipline::DEFAULT_NAMES[:la]
        short_name = short_name.presence || 'LA'
        key = :la
        single_discipline = false
      when 'Disciplines::ClimbingHookLadder'
        name = name.presence || Discipline::DEFAULT_NAMES[:hl]
        short_name = short_name.presence || 'HL'
        key = :hl
        single_discipline = true
      when 'Disciplines::DoubleEvent'
        name = name.presence || Discipline::DEFAULT_NAMES[:zk]
        short_name = short_name.presence || 'ZK'
        key = :zk
        single_discipline = true
      when 'Disciplines::FireRelay'
        name = name.presence || Discipline::DEFAULT_NAMES[:fs]
        short_name = short_name.presence || 'FS'
        key = :fs
        single_discipline = false
      when 'Disciplines::GroupRelay'
        name = name.presence || Discipline::DEFAULT_NAMES[:gs]
        short_name = short_name.presence || 'GS'
        key = :gs
        single_discipline = false
      when 'Disciplines::ObstacleCourse'
        name = name.presence || Discipline::DEFAULT_NAMES[:hb]
        short_name = short_name.presence || 'HB'
        key = :hb
        single_discipline = true
      end

      discipline = competition.disciplines.create!(key:, name:, short_name:, single_discipline:, like_fire_relay:)
      @disciplines_translations[id] = discipline.id
    end
  end

  def load_assessments
    @assessments_translations = {}
    @db.execute('SELECT id,name,discipline_id,band_id FROM assessments').each do |id, name, discipline_id, band_id|
      assessment = competition.assessments.create!(
        forced_name: name.strip.presence,
        discipline_id: @disciplines_translations[discipline_id],
        band_id: @bands_translations[band_id],
      )
      @assessments_translations[id] = assessment.id
    end
  end

  def load_score_results
    @score_results_translations = {}
    @db.execute('SELECT id,name,group_assessment,assessment_id,date,calculation_method FROM score_results')
       .each do |id, name, group_assessment, assessment_id, date, calculation_method|
      result = competition.score_results.create!(
        forced_name: name.strip.presence,
        assessment_id: @assessments_translations[assessment_id],
        group_assessment:,
        date:,
        calculation_method:,
      )
      @score_results_translations[id] = result.id
    end
  end

  def load_teams
    @teams_translations = {}
    @db.execute('SELECT id,name,number,shortcut,lottery_number,band_id,fire_sport_statistics_team_id FROM teams')
       .each do |id, name, number, shortcut, lottery_number, band_id, fss_id|
      team = competition.teams.create!(
        disable_autocreate_assessment_requests: true,
        name: name.strip,
        shortcut: shortcut.strip,
        number:,
        band_id: @bands_translations[band_id],
        lottery_number:,
        fire_sport_statistics_team_id: fss_id,
      )

      @teams_translations[id] = team.id
    end
  end

  def load_assessment_requests
    @assessment_requests_translations = {}
    sql = <<~SQL.squish
      SELECT
        id,assessment_id,entity_id,entity_type,assessment_type,
        group_competitor_order,relay_count,single_competitor_order,competitor_order
      FROM assessment_requests
    SQL
    @db.execute(sql).each do |id, assessment_id, entity_id, entity_type, assessment_type,
      group_competitor_order, relay_count, single_competitor_order, competitor_order|

      if entity_type == 'Team'
        entity_id = @teams_translations[entity_id]
      elsif entity_type == 'Person'
        entity_id = @people_translations[entity_id]
      else
        raise entity_type
      end

      assessment_request = Assessment.find(@assessments_translations[assessment_id]).requests.create!(
        assessment_id: @assessments_translations[assessment_id],
        entity_type:,
        entity_id:,
        assessment_type:,
        group_competitor_order:,
        relay_count:,
        single_competitor_order:,
        competitor_order:,
      )
      @assessment_requests_translations[id] = assessment_request.id
    end
  end

  def load_score_lists
    @score_lists_translations = {}
    sql = <<~SQL.squish
      SELECT
        id,name,shortcut,track_count,date,show_multiple_assessments,hidden,separate_target_times,show_best_of_run
      FROM score_lists
    SQL
    @db.execute(sql).each do |id, name, shortcut, track_count, date, show_multiple_assessments, hidden, separate_target_times, show_best_of_run|
      list = competition.score_lists.create!(
        name:,
        shortcut:,
        track_count:,
        date:,
        show_multiple_assessments:,
        hidden:,
        separate_target_times:,
        show_best_of_run:,
      )
      @score_lists_translations[id] = list.id
    end

    @db.execute('SELECT list_id,result_id FROM score_result_lists').each do |list_id, result_id|
      Score::ResultList.create!(
        list_id: @score_lists_translations[list_id],
        result_id: @score_results_translations[result_id],
      )
    end

    @db.execute('SELECT list_id,assessment_id FROM score_list_assessments').each do |list_id, assessment_id|
      Score::ListAssessment.create!(
        list_id: @score_lists_translations[list_id],
        assessment_id: @assessments_translations[assessment_id],
      )
    end
  end

  def load_score_list_entries
    sql = <<~SQL.squish
      SELECT
        list_id,entity_type,entity_id,track,run,result_type,assessment_type,assessment_id,time,time_left_target,time_right_target
      FROM score_list_entries
    SQL
    @db.execute(sql).each do |list_id, entity_type, entity_id, track, run, result_type, assessment_type, assessment_id, time, time_left_target, time_right_target|
      list = competition.score_lists.find(@score_lists_translations[list_id])
      if entity_type == 'Team'
        entity_id = @teams_translations[entity_id]
      elsif entity_type == 'Person'
        entity_id = @people_translations[entity_id]
      else
        raise entity_type.inspect
      end

      list.entries.create!(
        competition:,
        entity_type:,
        entity_id:,
        track:,
        run:,
        result_type:,
        assessment_type:,
        assessment_id: @assessments_translations[assessment_id],
        time:,
        time_left_target:,
        time_right_target:,
      )
    end
  end
end
