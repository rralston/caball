require 'spec_helper'
require 'request_helper'

describe Endorsement do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:receiver).class_name('User') }
    it { should belong_to(:sender).class_name('User') }
  end

end