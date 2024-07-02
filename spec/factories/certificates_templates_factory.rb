# frozen_string_literal: true

FactoryBot.define do
  factory :certificates_template, class: 'Certificates::Template' do
    competition
    name  { 'Einfache Vorlage' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/disciplines/hl.png')) }
    font { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/fonts/Arial.ttf')) }
  end

  factory :certificates_text_field, class: 'Certificates::TextField' do
    width { 100 }
    height { 20 }
    size { 10 }
    align { :center }

    trait :team_name do
      left { 10 }
      top { 10 }
      key { :team_name }
    end
    trait :free_text do
      left { 30 }
      top { 30 }
      key { :text }
      text { 'Hier kommt dein Text' }
    end
  end
end
