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
  end
end
