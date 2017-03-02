require 'spec_helper'

describe Mongoid::Archivable::ProcessLocalizedFields, 'localized fields' do
  let(:localized_field) { 'Localized field' }
  let(:archive_user) { User::Archive.first }

  before do
    User::Archive.destroy_all
    user.destroy
  end

  describe 'localized field' do
    let(:user) { User.create!(localized_field: localized_field) }

    it 'correctly restores' do
      original_document = archive_user.original_document
      expect(original_document.localized_field).to eq(localized_field)
    end
  end

  describe 'embedded documents' do
    let(:document_embedded_in_user) { DocumentEmbeddedInUser.new(localized_field: localized_field) }

    describe 'embeds_one relation' do
      let(:user) { User.create!(document_embedded_in_user: document_embedded_in_user) }

      it 'correctly restores' do
        original_document = archive_user.original_document
        original_document_embedded_in_user = original_document.document_embedded_in_user

        expect(original_document_embedded_in_user.localized_field).to eq(localized_field)
      end
    end

    describe 'embeds_many relation' do
      let(:user) { User.create!(documents_embedded_in_user: [document_embedded_in_user]) }

      it 'correctly restores' do
        original_document = archive_user.original_document
        original_document_embedded_in_user = original_document.documents_embedded_in_user.first

        expect(original_document_embedded_in_user.localized_field).to eq(localized_field)
      end
    end
  end
end
