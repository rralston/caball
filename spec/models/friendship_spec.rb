require 'spec_helper'
require 'request_helper'

describe Friendship do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name("User") }
  end

end