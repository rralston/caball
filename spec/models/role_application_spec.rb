require 'spec_helper'
require 'request_helper'

describe RoleApplication do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
    it { should have_one(:project).through(:role) }
  end

end