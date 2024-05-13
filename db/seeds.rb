# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create_with(password: 'Admin123', confirmed_at: Time.current)
           .find_or_create_by!(email: 'georf@georf.de', name: 'Georg Limbach')

c = Competition.create_with(date: 2.months.from_now).find_or_create_by!(
  name: 'Wettkampf ohne Text', user:, locality: 'Schwerin', visible: true,
)

c.disciplines.find_or_create_by(key: :la, name: Discipline::DEFAULT_NAMES[:la], short_name: 'LA',
                                single_discipline: false)

c = Competition.create_with(date: 2.months.from_now).find_or_create_by!(
  name: 'Wettkampf mit mehr Disziplinen', user:, locality: 'Wismar', visible: true,
)

c.disciplines.find_or_create_by(key: :la, name: Discipline::DEFAULT_NAMES[:la], short_name: 'LA',
                                single_discipline: false)
c.disciplines.find_or_create_by(key: :gs, name: Discipline::DEFAULT_NAMES[:gs], short_name: 'GS',
                                single_discipline: false)
c.disciplines.find_or_create_by(key: :hb, name: Discipline::DEFAULT_NAMES[:hb], short_name: 'HB',
                                single_discipline: true)
c.disciplines.find_or_create_by(key: :hl, name: Discipline::DEFAULT_NAMES[:hl], short_name: 'HL',
                                single_discipline: true)

c = Competition.create_with(date: 4.months.from_now).find_or_create_by!(
  name: 'Wettkampf mit Urkunden', user:, locality: 'Rostock', visible: true,
)

la = c.disciplines.find_or_create_by(key: :la, name: Discipline::DEFAULT_NAMES[:la], short_name: 'LA',
                                     single_discipline: false)
female = c.bands.find_or_create_by!(gender: :female, name: 'Frauen')
male = c.bands.find_or_create_by!(gender: :male, name: 'Männer')
c.assessments.find_or_create_by!(discipline: la, band: female)
c.assessments.find_or_create_by!(discipline: la, band: male)

template = c.certificates_templates.find_or_create_by(name: 'Beispielvorlage')
template.text_fields.destroy_all
template.text_fields.create!(
  left: '72.0',
  top: '793.0',
  width: '450.0',
  height: '120.0',
  size: 56,
  key: 'text',
  align: 'center',
  text: 'Urkunde',
  color: '000000',
  font: 'bold',
)
template.text_fields.create!(
  left: '42.0',
  top: '579.0',
  width: '510.0',
  height: '50.0',
  size: 36,
  key: 'team_name',
  align: 'center',
  text: '',
  color: '000000',
  font: 'bold',
)
template.text_fields.create!(
  left: '142.5',
  top: '679.0',
  width: '310.0',
  height: '20.0',
  size: 16,
  key: 'result_name',
  align: 'center',
  text: '',
  color: '000000',
  font: 'regular',
)
template.text_fields.create!(
  left: '187.0',
  top: '80.0',
  width: '220.0',
  height: '20.0',
  size: 16,
  key: 'competition_name',
  align: 'center',
  text: '',
  color: '000000',
  font: 'regular',
)
template.text_fields.create!(
  left: '418.0',
  top: '80.0',
  width: '160.0',
  height: '20.0',
  size: 16,
  key: 'place',
  align: 'center',
  text: '',
  color: '000000',
  font: 'regular',
)
template.text_fields.create!(
  left: '38.0',
  top: '80.0',
  width: '140.0',
  height: '20.0',
  size: 16,
  key: 'date',
  align: 'center',
  text: '',
  color: '000000',
  font: 'regular',
)
template.text_fields.create!(
  left: '122.0',
  top: '330.0',
  width: '350.0',
  height: '70.0',
  size: 36,
  key: 'rank_with_rank2',
  align: 'center',
  text: '',
  color: '000000',
  font: 'bold',
)
template.text_fields.create!(
  left: '92.0',
  top: '454.0',
  width: '410.0',
  height: '40.0',
  size: 21,
  key: 'time_very_long',
  align: 'center',
  text: '',
  color: '000000',
  font: 'regular',
)

ImportSuggestionsJob.perform_now if FireSportStatistics::Person.count < 100
