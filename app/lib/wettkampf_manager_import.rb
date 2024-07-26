# frozen_string_literal: true

class WettkampfManagerImport
  attr_reader :db, :competition

  def initialize(root_path)
    @root_path = root_path
    @db = SQLite3::Database.open(File.join(root_path, 'db/production.sqlite3'))

    @migration_bands = db.execute("SELECT * FROM schema_migrations WHERE version = '20230402151955'").present?
    @migration_calculation = db.execute("SELECT * FROM schema_migrations WHERE version = '20220828184511'").present?
    @migration_target_times = db.execute("SELECT * FROM schema_migrations WHERE version = '20220611192258'").present?

    user = User.find_by(email: 'georf@georf.de')

    name, date, place = @db.execute('SELECT name,date,place FROM competitions').first
    @competition = Competition.find_or_create_by!(
      name: name.first(49), place: place.first(49), visible: true, date:,
    )
    competition.users.push(user)

    competition.score_lists.destroy_all
    competition.people.destroy_all
    competition.teams.destroy_all
    competition.team_relays.destroy_all
    competition.score_results.destroy_all
    competition.assessments.destroy_all
    competition.disciplines.destroy_all
    competition.bands.destroy_all
    competition.certificates_templates.destroy_all

    load_bands
    load_disciplines
    load_assessments
    load_score_results
    load_teams
    load_team_relays
    load_people
    load_assessment_requests
    load_score_lists
    load_score_list_entries
    load_tags
    load_certificates
  end

  def load_bands
    @bands_translations = {}
    if @migration_bands
      @db.execute('SELECT id,gender,name,position FROM bands ORDER BY position').each do |id, gender, name, position|
        band = competition.bands.create!(gender:, name:, position:)
        @bands_translations[id] = band.id
      end
    else
      @bands_translations[0] = competition.bands.create!(gender: :female, name: 'Frauen', position: 1).id
      @bands_translations[1] = competition.bands.create!(gender: :male, name: 'Männer', position: 2).id
      @bands_translations[2] = competition.bands.create!(gender: :indifferent, name: 'Jugend', position: 3).id
      @bands_translations[3] = competition.bands.create!(gender: :indifferent, name: 'Kinder', position: 4).id
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
    if @migration_bands
      @db.execute('SELECT id,name,discipline_id,band_id FROM assessments').each do |id, name, discipline_id, band_id|
        assessment = competition.assessments.create!(
          forced_name: name.strip.presence,
          discipline_id: @disciplines_translations[discipline_id],
          band_id: @bands_translations[band_id],
        )
        @assessments_translations[id] = assessment.id
      end
    else
      @db.execute('SELECT id,name,discipline_id,gender FROM assessments').each do |id, name, discipline_id, gender|
        assessment = competition.assessments.create!(
          forced_name: name.strip.presence,
          discipline_id: @disciplines_translations[discipline_id],
          band_id: @bands_translations[gender],
        )
        @assessments_translations[id] = assessment.id
      end
    end
  end

  def load_score_results
    @score_results_translations = {}
    sql = if @migration_calculation
            'SELECT id,name,group_assessment,assessment_id,date,calculation_method,type FROM score_results'
          else
            "SELECT id,name,group_assessment,assessment_id,date,'default',type FROM score_results"
          end

    @db.execute(sql)
       .each do |id, name, group_assessment, assessment_id, date, calculation_method, type|
      calculation_method = :zweikampf if type == 'Score::DoubleEventResult'
      result = competition.score_results.create!(
        forced_name: name.strip.presence,
        assessment_id: @assessments_translations[assessment_id],
        group_assessment:,
        date:,
        calculation_method:,
      )
      @score_results_translations[id] = result.id
    end
    @db.execute('SELECT id,double_event_result_id FROM score_results').each do |id, double_event_result_id|
      competition.score_results.find(@score_results_translations[id])
                 .update!(double_event_result_id: @score_results_translations[double_event_result_id])
    end
  end

  def load_teams
    @teams_translations = {}
    if @migration_bands
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
    else
      @db.execute('SELECT id,name,number,shortcut,lottery_number,gender,fire_sport_statistics_team_id FROM teams')
         .each do |id, name, number, shortcut, lottery_number, gender, fss_id|
        team = competition.teams.create!(
          disable_autocreate_assessment_requests: true,
          name: name.strip,
          shortcut: shortcut.strip,
          number:,
          band_id: @bands_translations[gender],
          lottery_number:,
          fire_sport_statistics_team_id: fss_id,
        )

        @teams_translations[id] = team.id
      end
    end
  end

  def load_team_relays
    @team_relays_translations = {}
    @db.execute('SELECT id,team_id,number FROM team_relays')
       .each do |id, team_id, number|
      relay = TeamRelay.create!(
        team_id: @teams_translations[team_id],
        number:,
      )

      @team_relays_translations[id] = relay.id
    end
  end

  def load_people
    @people_translations = {}
    if @migration_bands
      @db.execute(
        'SELECT id,last_name,first_name,team_id,bib_number,fire_sport_statistics_person_id,band_id FROM people',
      )
         .each do |id, last_name, first_name, team_id, bib_number, fss_id, band_id|
        person = competition.people.create!(
          last_name:,
          first_name:,
          team_id: @teams_translations[team_id],
          bib_number:,
          fire_sport_statistics_person_id: fss_id,
          band_id: @bands_translations[band_id],
        )

        @people_translations[id] = person.id
      end
    else
      @db.execute(
        'SELECT id,last_name,first_name,team_id,bib_number,fire_sport_statistics_person_id,gender FROM people',
      )
         .each do |id, last_name, first_name, team_id, bib_number, fss_id, gender|
        person = competition.people.create!(
          last_name:,
          first_name:,
          team_id: @teams_translations[team_id],
          bib_number:,
          fire_sport_statistics_person_id: fss_id,
          band_id: @bands_translations[gender],
        )

        @people_translations[id] = person.id
      end
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
    sql = if @migration_target_times
            <<~SQL.squish
              SELECT
                id,name,shortcut,track_count,date,show_multiple_assessments,hidden,separate_target_times
              FROM score_lists
            SQL
          else
            <<~SQL.squish
              SELECT
                id,name,shortcut,track_count,date,show_multiple_assessments,hidden,false
              FROM score_lists
            SQL
          end
    @db.execute(sql).each do |id, name, shortcut, track_count, date, show_multiple_assessments, hidden,
      separate_target_times|
      list = competition.score_lists.create!(
        name:,
        shortcut:,
        track_count:,
        date:,
        show_multiple_assessments:,
        hidden:,
        separate_target_times:,
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
    if @migration_target_times
      sql = <<~SQL.squish
        SELECT
          list_id,entity_type,entity_id,track,run,result_type,assessment_type,assessment_id,time,time_left_target,time_right_target
        FROM score_list_entries
      SQL
    else
      sql = <<~SQL.squish
        SELECT
          list_id,entity_type,entity_id,track,run,result_type,assessment_type,assessment_id,time,NULL,NULL
        FROM score_list_entries
      SQL
    end
    @db.execute(sql).each do |list_id, entity_type, entity_id, track, run, result_type, assessment_type,
      assessment_id, time, time_left_target, time_right_target|
      list = competition.score_lists.find(@score_lists_translations[list_id])
      case entity_type
      when 'Team'
        entity_id = @teams_translations[entity_id]
      when 'Person'
        entity_id = @people_translations[entity_id]
      when 'TeamRelay'
        entity_id = @team_relays_translations[entity_id]
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

  def load_tags
    tags = {}
    @db.execute('SELECT id,name,type FROM tags').each do |id, name, type|
      tags[id] = [name, type]
    end

    if @migration_bands
      @db.execute("SELECT tag_id,taggable_id FROM tag_references WHERE taggable_type = 'Band'")
         .each do |tag_id, band_id|
        tag = tags[tag_id]
        band = competition.bands.find(@bands_translations[band_id])
        if tag[1] == 'PersonTag'
          band.person_tags = band.person_tags + [tag[0]]
        elsif tag[1] == 'TeamTag'
          band.team_tags = band.team_tags + [tag[0]]
        end
        band.save!
      end
    else
      competition.bands.each do |band|
        tags.each_value do |tag|
          if tag[1] == 'PersonTag'
            band.person_tags = band.person_tags + [tag[0]]
          elsif tag[1] == 'TeamTag'
            band.team_tags = band.team_tags + [tag[0]]
          end
          band.save!
        end
      end
    end

    @db.execute("SELECT tag_id,taggable_id FROM tag_references WHERE taggable_type = 'Team'").each do |tag_id, team_id|
      tag = tags[tag_id]
      team = competition.teams.find(@teams_translations[team_id])
      team.tags = team.tags + [tag[0]] if tag[1] == 'TeamTag'
      team.save!
    end

    @db.execute("SELECT tag_id,taggable_id FROM tag_references WHERE taggable_type = 'Person'")
       .each do |tag_id, person_id|
      tag = tags[tag_id]
      person = competition.people.find(@people_translations[person_id])
      person.tags = person.tags + [tag[0]] if tag[1] == 'PersonTag'
      person.save!
    end

    @db.execute("SELECT tag_id,taggable_id FROM tag_references WHERE taggable_type = 'Score::Result'")
       .each do |tag_id, result_id|
      tag = tags[tag_id]
      result = competition.score_results.find(@score_results_translations[result_id])
      if tag[1] == 'PersonTag'
        result.person_tags_included = result.person_tags_included + [tag[0]]
      elsif tag[1] == 'TeamTag'
        result.team_tags_included = result.team_tags_included + [tag[0]]
      end
      result.save!
    end
  end

  def load_certificates
    @certificates_templates_translations = {}
    @db.execute('SELECT id,name FROM certificates_templates').each do |id, name|
      template = competition.certificates_templates.create!(
        name:,
      )
      @certificates_templates_translations[id] = template.id
    end

    @db.execute('SELECT template_id,left,top,width,height,size,key,align,text,font,color FROM certificates_text_fields')
       .each do |template_id, left, top, width, height, size, key, align, text, font, color|
      key = 'rank_with_rank2' if key == 'rank_with_rank_2'

      Certificates::TextField.create!(
        template_id: @certificates_templates_translations[template_id],
        left:,
        top:,
        width:,
        height:,
        size:,
        key:,
        align:,
        text:,
        font:,
        color:,
      )
    end

    @db.execute(
      "SELECT name,record_id,blob_id FROM active_storage_attachments WHERE record_type = 'Certificates::Template'",
    ).each do |name, record_id, blob_id|
      template = Certificates::Template.find_by(id: @certificates_templates_translations[record_id])
      next if template.nil?

      filename = @db.execute("SELECT filename FROM active_storage_blobs WHERE id = '#{blob_id}'").first[0]
      filepath = File.join(@root_path, 'tmp/certificates', record_id.to_s, filename)

      template.send(name).attach(io: File.open(filepath), filename:)
    end
  end
end
