# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'errors' do
  describe 'GET not_found' do
    it 'renders form' do
      get '/not_found'
      expect(response).to match_html_fixture
    end
  end

  describe 'GET internal_server_error' do
    it 'renders form' do
      get '/internal_server_error'
      expect(response).to match_html_fixture
    end
  end

  describe 'GET unprocessable_entity' do
    it 'renders form' do
      get '/unprocessable_entity'
      expect(response).to match_html_fixture
    end
  end
end
