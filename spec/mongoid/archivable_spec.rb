require 'spec_helper'

describe Mongoid::Archivable do
  it 'has a version number' do
    expect(Mongoid::Archivable::VERSION).not_to be nil
  end
end
