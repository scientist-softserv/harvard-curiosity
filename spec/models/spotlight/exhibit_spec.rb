# frozen_string_literal: true

require 'rails_helper'

describe Spotlight::Exhibit, type: :model do
  subject(:exhibit) { build(:exhibit) }

  # See app/models/spotlight/exhibit_decorator.rb
  describe '#load_default_field_config' do
    before do
      exhibit.blacklight_configuration = Spotlight::BlacklightConfiguration.new
    end

    it "loads the default field config into the exhibit's associated BlacklightConfiguration record" do
      expect(exhibit.blacklight_configuration.index_fields).to be_a(Hash)
      expect(exhibit.blacklight_configuration.index_fields).to be_empty

      exhibit.load_default_field_config
      exhibit.reload

      expect(exhibit.blacklight_configuration.index_fields).to be_a(Hash)
      expect(exhibit.blacklight_configuration.index_fields).to be_present
    end

    context 'when creating a new exhibit' do
      it 'triggers the after_create callback' do
        expect(exhibit).to receive(:load_default_field_config).once # rubocop:disable RSpec/SubjectStub

        exhibit.save!
      end
    end

    context 'when saving an existing exhibit' do
      before do
        exhibit.save!
      end

      it 'does not trigger the after_create callback' do
        expect(exhibit).not_to receive(:load_default_field_config) # rubocop:disable RSpec/SubjectStub

        exhibit.save!
      end
    end
  end
end
