# frozen_string_literal: true

require 'rails_helper'

describe SolrDocument, type: :model do
  let(:document) { described_class.new(id: 'abcd123') }

  before do
    allow(document).to receive_messages(reindex: nil)
  end

  describe 'uploaded resources' do
    let(:uploaded_resource) do
      described_class.new(
        spotlight_resource_type_ssim: 'spotlight/resources/uploads'
      )
    end

    it 'does not include Spotlight::SolrDocument::UploadedResource when the correct fields are present' do
      expect(document).not_to be_kind_of Spotlight::SolrDocument::UploadedResource
    end

    it 'includes Spotlight::SolrDocument::UploadedResource when the correct fields are present' do
      expect(uploaded_resource).to be_kind_of Spotlight::SolrDocument::UploadedResource
    end

    describe '#uploaded_resource?' do
      it 'returns false if the correct fields are not present' do
        expect(document).not_to be_uploaded_resource
      end

      it 'returns true when the correct fields are present' do
        expect(uploaded_resource).to be_uploaded_resource
      end
    end
  end
end
