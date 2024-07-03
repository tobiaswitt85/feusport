# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  describe '#create_assessment_requests' do
    let(:competition) { create(:competition) }
    let(:band) { create(:band, :female, competition:) }

    let(:hl) { create(:discipline, :hl, competition:) }
    let(:la) { create(:discipline, :la, competition:) }
    let(:fs) { create(:discipline, :fs, competition:) }
    let!(:assessment_hl) { create(:assessment, competition:, discipline: hl, band:) }
    let!(:assessment_la) { create(:assessment, competition:, discipline: la, band:) }
    let!(:assessment_fs) { create(:assessment, competition:, discipline: fs, band:) }

    let(:team) { create(:team, competition:, band:) }

    it 'creates assessment requests for all available assessments' do
      requests = team.requests.sort_by(&:relay_count)
      expect(requests.count).to eq 2
      expect(requests.first.assessment).to eq assessment_la
      expect(requests.first.relay_count).to eq 1
      expect(requests.second.assessment).to eq assessment_fs
      expect(requests.second.relay_count).to eq 2
    end
  end
end
