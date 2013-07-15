require 'spec_helper'
require 'request_helper'

describe ProjectDate do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:project) }
  end

  context "date formatting methods" do
    before(:all){
      @p_date = FactoryGirl.create(:project_date, :date_time => '2013-12-18 14:55')
    }
    subject { @p_date }

    its(:full_date) { should == '2013-12-18' }
    its(:date) { should == '18' }
    its(:year) { should == '2013' }
    its(:month) { should == '12' }
    its(:month_year) { should == 'Dec \'13' }

    its(:time) { should == '14:55' }
    its(:formatted_time) { should == '02:55pm' }
  end
  
end