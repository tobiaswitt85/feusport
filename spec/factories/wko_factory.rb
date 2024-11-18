# frozen_string_literal: true

FactoryBot.define do
  factory :wko do
    slug { '2023' }
    name { 'WKO 2023' }
    subtitle { 'DFV-Wettkampfordnung - 4. Auflage 2023' }
    description_md { "**Wichtig**\n\nEs folgt *nichts*" }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/doc.pdf')) }
  end
end
