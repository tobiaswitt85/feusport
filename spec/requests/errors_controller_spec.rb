# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'errors' do
  describe 'GET not_found' do
    it 'renders form' do
      get '/not_found'
      expect(response).to be_successful
      Rails.public_path.join('404.html').write(response.body)
    end
  end

  describe 'GET internal_server_error' do
    it 'renders form' do
      get '/internal_server_error'
      expect(response).to be_successful
      Rails.public_path.join('500.html').write(response.body)
    end
  end

  describe 'GET unprocessable_entity' do
    it 'renders form' do
      get '/unprocessable_entity'
      expect(response).to be_successful
      Rails.public_path.join('422.html').write(response.body)
    end
  end
end
