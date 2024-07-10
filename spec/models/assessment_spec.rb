# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assessment do
  let(:competition) { create(:competition) }
  let(:other_competition) { create(:competition) }
  let(:assessment) { create(:assessment, competition:) }
  let(:discipline) { create(:discipline, :hl, competition: other_competition) }

  describe 'auto registration_open_until' do
    it 'changes automaticly' do
      expect(assessment).to be_valid

      assessment.discipline = discipline
      expect(assessment).not_to be_valid
      expect(assessment.errors.attribute_names).to eq [:discipline]
    end
  end
end
