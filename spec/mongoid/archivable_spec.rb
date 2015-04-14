require 'spec_helper'

describe Mongoid::Archivable do

  it 'has a version number' do
    expect(Mongoid::Archivable::VERSION).not_to be nil
  end

  before do
    Mongoid.purge!
  end

  let(:user) { User.create! }
  let(:archive_user) { User::Archive.first }

  it "does delete a document" do
    user.destroy
    expect(User.count).to be(0)
  end

  it "archives said document" do
    expect {
      user.destroy
    }.to change(User::Archive, :count).by(1)
  end

  it "stores the archive date" do
    user.destroy
    expect(archive_user.archived_at).to be_present
  end

  it "stores the original id" do
    user.destroy
    expect(archive_user.original_id).to be_present
  end

  it "allows the document to be restored" do
    user.destroy
    expect {
      archive_user.restore
    }.to change(User, :count).by(1)
  end

  it "retains the original id after restore" do
    original_id = user.id
    user.destroy
    archive_user.restore
    expect(User.last.id).to eq(original_id)
  end
end
