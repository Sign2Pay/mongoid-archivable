require 'spec_helper'

describe Mongoid::Archivable::Config do
  let(:user) { UserTenant.create! }
  let(:archive_user) { UserTenant::Archive.first }

  before do
    Deeply::Nested::UserTenant::Archive.destroy_all
    UserTenant::Archive.destroy_all
    user.destroy
  end
  
  it 'uses database archives' do
    expect(UserTenant::Archive.collection.database.name).to eq('archives')
  end

  it 'uses namespace archives.user_archives' do
    expect(UserTenant::Archive.collection.namespace).to eq('archives.user_archives')
  end

  it 'does delete a document' do
    expect(UserTenant.count).to be(0)
  end

  it 'allows the document to be restored' do
    expect do
      archive_user.restore
    end.to change(User, :count).by(1)
  end

  describe 'deeply nested' do
    let(:user) { Deeply::Nested::UserTenant.create! }
    let(:archive_user) { Deeply::Nested::UserTenant::Archive.first }
    let(:original_id) { user.id }

    it 'works' do
      archive_user.restore
      expect(Deeply::Nested::UserTenant.last.id).to eq(original_id)
    end
  end
end
