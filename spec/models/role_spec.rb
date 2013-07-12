require 'spec_helper'
require 'request_helper'

describe Role do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:project) }
    it { should have_many(:applications).class_name("RoleApplication").dependent(:destroy) }
  end

end