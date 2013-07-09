require 'spec_helper'
require 'request_helper'

describe Talent do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:user) }
  end

end