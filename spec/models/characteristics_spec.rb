require 'spec_helper'
require 'request_helper'

describe Characteristics do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:user) }
  end

  context "completeness" do
    before(:all){
      @c1 = FactoryGirl.create(:characteristics, :age => 12, :height => 5.9, :weight => 78, :ethnicity => 'Asian', :bodytype => 'slim',
                 :skin_color => 'brown', :eye_color => 'brown', :hair_color => "black", :chest => 10, :waist => 32, :hips => 23, :dress_size => 23)
      @c3 = FactoryGirl.create(:characteristics, :age => 12, :height => 5.9, :weight => 78, :ethnicity => 'Asian', :bodytype => 'slim')
      @c2 = FactoryGirl.create(:characteristics)
    }

    specify { @c1.completeness_sum.should == 12 }
    specify { @c2.completeness_sum.should == 0 }
    specify { @c3.completeness_sum.should == 5 }
  end

end