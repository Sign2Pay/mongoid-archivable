require 'spec_helper'

describe Mongoid::Archivable, 'restore' do
  let(:localized_field) { 'Localized field' }
  let(:user) { User.create!(localized_field: localized_field) }
  let(:archive_user) { User::Archive.first }
  let(:original_id) { user.id }

  before do
    user.destroy
  end

  it 'allows the document to be restored' do
    expect do
      archive_user.restore
    end.to change(User, :count).by(1)
  end

  it 'retains the original id after restore' do
    archive_user.restore
    expect(User.last.id).to eq(original_id)
  end

  it 'correctly restores localized fields' do
    original_document = archive_user.original_document
    expect(original_document.localized_field).to eq(localized_field)
  end

  describe 'STI classes' do
    let(:user) { UserSubclass.create! }
    let(:archive_user) { UserSubclass::Archive.first }

    it 'works' do
      archive_user.restore
      expect(UserSubclass.last.id).to eq(original_id)
    end
  end

  describe 'deeply nested' do
    let(:user) { Deeply::Nested::User.create! }
    let(:archive_user) { Deeply::Nested::User::Archive.first }

    it 'works' do
      archive_user.restore
      expect(Deeply::Nested::User.last.id).to eq(original_id)
    end
  end
end
