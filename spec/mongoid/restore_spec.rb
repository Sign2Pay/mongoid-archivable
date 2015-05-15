require 'spec_helper'

describe Mongoid::Archivable, "restore" do

  let(:user) { User.create! }
  let(:archive_user) { User::Archive.first }
  let(:original_id) { user.id }

  before do
    user.destroy
  end

  it "allows the document to be restored" do
    expect {
      archive_user.restore
    }.to change(User, :count).by(1)
  end

  it "retains the original id after restore" do
    archive_user.restore
    expect(User.last.id).to eq(original_id)
  end

  describe "deeply nested" do

    let(:user) { Deeply::Nested::User.create! }
    let(:archive_user) { Deeply::Nested::User::Archive.first }

    it "works" do
      archive_user.restore
      expect(Deeply::Nested::User.last.id).to eq(original_id)
    end

  end

end
