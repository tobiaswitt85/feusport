# frozen_string_literal: true

class FireSportStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table 'fire_sport_statistics_people', force: :cascade do |t|
      t.string 'last_name', null: false, limit: 100
      t.string 'first_name', null: false, limit: 100
      t.integer 'gender', null: false
      t.boolean 'dummy', default: false, null: false
      t.integer 'personal_best_hb'
      t.string 'personal_best_hb_competition'
      t.integer 'personal_best_hl'
      t.string 'personal_best_hl_competition'
      t.integer 'personal_best_zk'
      t.string 'personal_best_zk_competition'
      t.integer 'saison_best_hb'
      t.string 'saison_best_hb_competition'
      t.integer 'saison_best_hl'
      t.string 'saison_best_hl_competition'
      t.integer 'saison_best_zk'
      t.string 'saison_best_zk_competition'
      t.timestamps
    end

    create_table 'fire_sport_statistics_person_spellings', force: :cascade do |t|
      t.string 'last_name', null: false, limit: 100
      t.string 'first_name', null: false, limit: 100
      t.integer 'gender', null: false
      t.integer 'person_id', null: false
      t.index ['person_id']
      t.timestamps
    end

    create_table 'fire_sport_statistics_team_associations', force: :cascade do |t|
      t.integer 'person_id', null: false
      t.integer 'team_id', null: false
      t.index ['person_id']
      t.index ['team_id']
      t.timestamps
    end

    create_table 'fire_sport_statistics_team_spellings', force: :cascade do |t|
      t.string 'name', null: false, limit: 100
      t.string 'short', null: false, limit: 50
      t.integer 'team_id', null: false
      t.index ['team_id']
      t.timestamps
    end

    create_table 'fire_sport_statistics_teams', force: :cascade do |t|
      t.string 'name', null: false, limit: 100
      t.string 'short', null: false, limit: 50
      t.boolean 'dummy', default: false, null: false
      t.timestamps
    end

    create_table 'series_rounds', force: :cascade do |t|
      t.string 'name', null: false, limit: 100
      t.integer 'year', null: false
      t.string 'aggregate_type', null: false, limit: 100
      t.integer 'full_cup_count', default: 4, null: false
      t.timestamps
    end

    create_table 'series_assessments', force: :cascade do |t|
      t.integer 'round_id', null: false
      t.string 'discipline', null: false, limit: 2
      t.string 'name', default: '', null: false
      t.string 'type', null: false, limit: 100
      t.integer 'gender', null: false
      t.timestamps
    end

    create_table 'series_cups', force: :cascade do |t|
      t.integer 'round_id', null: false
      t.string 'competition_place', null: false, limit: 100
      t.date 'competition_date', null: false
      t.uuid 'dummy_for_competition_id'
      t.timestamps
    end

    create_table 'series_participations', force: :cascade do |t|
      t.integer 'assessment_id', null: false
      t.integer 'cup_id', null: false
      t.string 'type', null: false, limit: 100
      t.integer 'team_id'
      t.integer 'team_number'
      t.integer 'person_id'
      t.integer 'time', null: false
      t.integer 'points', default: 0, null: false
      t.integer 'rank', null: false
      t.timestamps
    end
  end
end
