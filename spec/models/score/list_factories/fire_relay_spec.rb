# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListFactories::FireRelay do
  let(:competition) { create(:competition) }
  let(:band) { create(:band, :female, competition:) }

  let(:discipline) { create(:discipline, :fs, competition:) }
  let(:assessment) { create(:assessment, competition:, discipline:, band:) }
  let(:before_assessment) { create(:assessment, competition:, discipline:, band:) }
  let(:result) { create(:score_result, competition:, assessment:) }
  let(:before_result) { create(:score_result, competition:, assessment:) }

  let(:list) { create(:score_list, competition:, assessments: [assessment], results: [result]) }

  let(:factory) do
    described_class.new(
      competition:, session_id: '1',
      discipline:, assessments: [assessment], name: 'long name',
      shortcut: 'short', track_count: 2, results: [result],
      before_result:, best_count: 2
    )
  end

  describe '#perform_rows' do
    let!(:assessment_request1) { create(:assessment_request, assessment:, relay_count: 2) }
    let!(:assessment_request2) { create(:assessment_request, assessment:, relay_count: 1) }
    let!(:assessment_request3) { create(:assessment_request, assessment:, relay_count: 2) }

    it 'returns created team relays in request structs' do
      team_relay_requests = factory.send(:perform_rows)
      team_relays = team_relay_requests.map(&:entity)
      expect(team_relays.count).to eq 5
      expect(team_relays.map(&:name)).to eq %w[A A A B B]

      team1_requests = team_relays.select { |tr| tr.team == assessment_request1.entity }
      expect(team1_requests.map(&:name)).to eq %w[A B]

      team2_requests = team_relays.select { |tr| tr.team == assessment_request2.entity }
      expect(team2_requests.map(&:name)).to eq ['A']

      team3_requests = team_relays.select { |tr| tr.team == assessment_request3.entity }
      expect(team3_requests.map(&:name)).to eq %w[A B]
    end
  end
end
