require 'spec_helper'

describe Mongoid::Archivable do
  it 'has a version number' do
    expect(Mongoid::Archivable::VERSION).not_to be nil
  end

  it 'has a config' do
    expect(defined?(Mongoid::Archivable::Config)).not_to be nil
  end

  let(:user) { User.create! }
  let(:archive_user) { User::Archive.first }

  before do
    User::Archive.destroy_all
  end

  it 'does delete a document' do
    user.destroy
    expect(User.count).to be(0)
  end

  it 'archives said document' do
    expect do
      user.destroy
    end.to change(User::Archive, :count).by(1)
  end

  it 'stores the archive date' do
    user.destroy
    expect(archive_user.archived_at).to be_present
  end

  it 'stores the original id' do
    user.destroy
    expect(archive_user.original_id).to be_present
  end

  it 'stores the original type' do
    user.destroy
    expect(archive_user.original_type).to be_present
  end
end
