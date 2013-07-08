require 'spec_helper'
require 'request_helper'

describe Photo do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:imageable) }
  end

end