# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home' do
  let!(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  describe 'home' do
    it 'shows home page' do
      get '/'
      expect(response).to match_html_fixture
    end
  end

  describe 'info' do
    it 'shows info page' do
      get '/info'
      expect(response).to match_html_fixture
    end
  end

  describe 'disseminators' do
    it 'shows disseminators page' do
      get '/disseminators'
      expect(response).to redirect_to '/users/sign_in'
      follow_redirect!

      sign_in user

      get '/disseminators'
      expect(response).to match_html_fixture
    end
  end
end
