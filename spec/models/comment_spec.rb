require 'spec_helper'
require 'request_helper'

describe Comment do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

end
