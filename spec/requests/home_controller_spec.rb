# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home' do
  let!(:competition) { create(:competition) }

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
end
