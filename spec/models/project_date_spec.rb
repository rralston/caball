require 'spec_helper'
require 'request_helper'

describe ProjectDate do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:project) }
  end
  
end