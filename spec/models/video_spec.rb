require 'spec_helper'
require 'request_helper'

describe Video do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:videoable) }
  end

end