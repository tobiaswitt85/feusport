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

Competition.create_with(date: 2.months.from_now).find_or_create_by!(
  name: 'MV-Cup', user:, locality: 'Schwerin', visible: true,
)

ImportSuggestionsJob.perform_now if FireSportStatistics::Person.count < 100
