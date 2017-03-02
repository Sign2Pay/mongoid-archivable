require 'spec_helper'

describe Mongoid::Archivable::Config do
  let(:user) { User.create! }
  let(:archive_user) { User::Archive.first }

  before do
    Mongoid::Archivable.configure do |config|
      config.database = "archives_test"
      config.client = "secondary"
    end
    Deeply::Nested::User::Archive.destroy_all
    User::Archive.destroy_all
    user.destroy
  end
  
  it 'uses database archives_test' do
    expect(User::Archive.collection.database.name).to eq('archives_test')
  end

  it 'uses namespace archives_test.user_archives' do
    expect(User::Archive.collection.namespace).to eq('archives_test.user_archives')
  end

  it 'does delete a document' do
    expect(User.count).to be(0)
  end

  it 'allows the document to be restored' do
    expect do
      archive_user.restore
    end.to change(User, :count).by(1)
  end

  describe 'deeply nested' do
    let(:user) { Deeply::Nested::User.create! }
    let(:archive_user) { Deeply::Nested::User::Archive.first }
    let(:original_id) { user.id }

    it 'works' do
      archive_user.restore
      expect(Deeply::Nested::User.last.id).to eq(original_id)
    end
  end
end
