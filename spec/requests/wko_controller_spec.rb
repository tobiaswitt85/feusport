# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wko do
  let(:wko) { create(:wko) }

  describe 'GET /wko/2023' do
    before do
      view_sanitizer.gsub(%r{active_storage/blobs/redirect/[^/]+/}, 'BLOBID')
      view_sanitizer.gsub(%r{active_storage/representations/redirect/[^/]+/[^/]+/}, 'BLOBID')
    end

    it_renders 'wko description' do
      get "/wko/#{wko.slug}"
    end
  end
end
