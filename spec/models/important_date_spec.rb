require 'spec_helper'
require 'request_helper'

describe ImportantDate do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:important_dateable) }
  end

  context "date formatting methods" do
    before(:all){
      @p_date = FactoryGirl.create(:important_date, :date_time => '2013-12-18 14:55', :description => 'sample')
    }
    subject { @p_date }

    its(:full_date) { should == '2013-12-18' }
    its(:day) { should == '18' }
    its(:year) { should == '2013' }
    its(:month) { should == '12' }
    its(:month_string) { should == 'Dec' }
    its(:month_year) { should == 'Dec \'13' }

    its(:time) { should == '14:55' }
    its(:formatted_time) { should == '02:55pm' }
    its(:pretty_date) { should == 'Dec 18, 2013 02:55pm' }
  end

  context "validation" do 
    before(:all){
      @x_date = FactoryGirl.build(:important_date, :date_time => '2013-12-18 14:55')
      @y_date = FactoryGirl.build(:important_date, :date_time => '2013-12-18 14:55', :is_start_date => true)
      @z_date = FactoryGirl.build(:important_date, :date_time => '2013-12-18 14:55', :is_end_date => true)
      @y_date.valid?
      @x_date.valid?
      @z_date.valid?
    }

    specify { @x_date.valid?.should == false }
    specify { @x_date.errors.full_messages.to_s.should include('Description is required') }

    specify { @y_date.valid?.should == true }
    specify { @z_date.valid?.should == true }
    
  end
  
end