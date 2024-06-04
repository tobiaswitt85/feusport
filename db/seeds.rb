# frozen_string_literal: true

ImportSuggestionsJob.perform_now if FireSportStatistics::Person.count < 100

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
female_assessment = c.assessments.find_or_create_by!(discipline: la, band: female)
male_assessment = c.assessments.find_or_create_by!(discipline: la, band: male)
c.score_results.find_or_create_by!(assessment: female_assessment)
c.score_results.find_or_create_by!(assessment: male_assessment)

c.teams.find_or_create_by!(band: male, name: 'FF Männlich', shortcut: 'Männlich')
c.teams.find_or_create_by!(band: male, name: 'FF Männlich', shortcut: 'Männlich', number: 2)
c.teams.find_or_create_by!(band: male, name: 'FF Anders', shortcut: 'Anders')
c.teams.find_or_create_by!(band: male, name: 'FF Berlin', shortcut: 'Berlin')
c.teams.find_or_create_by!(band: female, name: 'FF Weiblich', shortcut: 'Weiblich')

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
