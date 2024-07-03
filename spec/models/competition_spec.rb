# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition do
  let(:competition) { create(:competition) }

  describe 'auto registration_open_until' do
    it 'changes automaticly' do
      expect(competition.registration_open_until).to eq Date.parse('2024-02-28')

      competition.update!(date: Date.parse('2024-02-02'))
      expect(competition.registration_open_until).to eq Date.parse('2024-02-01')

      competition.update!(date: Date.parse('2024-02-10'))
      expect(competition.registration_open_until).to eq Date.parse('2024-02-01')
    end
  end
end
