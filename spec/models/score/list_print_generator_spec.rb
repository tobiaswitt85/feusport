# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListPrintGenerator do
  describe 'validation' do
    let(:competition) { create(:competition) }

    it 'checks print_list' do
      instance = described_class.new(print_list: 'a', competition:)
      expect(instance).not_to be_valid
      expect(instance.errors.attribute_names).to include :print_list

      instance.print_list = "page\ncolumn"
      expect(instance).to be_valid

      instance.print_list = "page\ncolumn\n#{SecureRandom.uuid}"
      expect(instance).to be_valid

      instance.print_list = "page\ncolumn\n#{SecureRandom.uuid}\nfoo"
      expect(instance).not_to be_valid
      expect(instance.errors.attribute_names).to include :print_list

      expect(instance.print_list_extended).to eq %w[page column]
    end
  end
end
