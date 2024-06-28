# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'suggestions' do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  describe 'GET teams' do
    let!(:team) { create(:fire_sport_statistics_team) }

    it 'returns teams' do
      post '/fire_sport_statistics/suggestions/teams'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq([{ 'id' => team.id, 'name' => 'Mecklenburg-Vorpommern',
                                            'short' => 'Team MV' }])

      post '/fire_sport_statistics/suggestions/teams', params: { name: 'mv' }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq([{ 'id' => team.id, 'name' => 'Mecklenburg-Vorpommern',
                                            'short' => 'Team MV' }])

      post '/fire_sport_statistics/suggestions/teams', params: { name: 'foo' }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq([])
    end
  end

  describe 'GET people' do
    let!(:person) { create(:fire_sport_statistics_person) }

    it 'returns people' do
      post '/fire_sport_statistics/suggestions/people'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq([{ 'first_name' => 'Alfred',
                                            'gender' => 'male',
                                            'id' => person.id,
                                            'last_name' => 'Meier',
                                            'teams' => [] }])

      post '/fire_sport_statistics/suggestions/people', params: { name: 'alfred' }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq([{ 'first_name' => 'Alfred',
                                            'gender' => 'male',
                                            'id' => person.id,
                                            'last_name' => 'Meier',
                                            'teams' => [] }])

      post '/fire_sport_statistics/suggestions/people', params: { name: 'alfred', team_name: 'mv' }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq([{ 'first_name' => 'Alfred',
                                            'gender' => 'male',
                                            'id' => person.id,
                                            'last_name' => 'Meier',
                                            'teams' => [] }])

      post '/fire_sport_statistics/suggestions/people', params: { name: 'peter' }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.parsed_body).to eq([])
    end
  end
end
