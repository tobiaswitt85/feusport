# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMarkerValue do
  let(:team_marker) { build(:team_marker) }

  it 'shows values' do
    value = described_class.new(team_marker:)

    expect(value.value).to eq 'Nein'
    expect(value.value_present?).to be true
    value.boolean_value = false
    expect(value.value).to eq 'Nein'
    expect(value.value_present?).to be true
    value.boolean_value = true
    expect(value.value).to eq 'Ja'
    expect(value.value_present?).to be true

    team_marker.value_type = :date
    expect(value.value).to be_nil
    expect(value.value_present?).to be false
    value.date_value = Date.current
    expect(value.value).to eq I18n.l(Date.current)
    expect(value.value_present?).to be true

    team_marker.value_type = :string
    expect(value.value).to be_nil
    expect(value.value_present?).to be false
    value.string_value = 'text'
    expect(value.value).to eq 'text'
    expect(value.value_present?).to be true
  end
end
