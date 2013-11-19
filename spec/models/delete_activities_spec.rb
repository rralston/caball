require 'spec_helper'
require 'request_helper'

describe DeleteActivities do
  before(:all) do
    clean!
  end
    
  context "Delete past 1 day update activities" do 

    before do
      @user = FactoryGirl.create(:user)

      @project = FactoryGirl.create(:project, :title => 'Act Check', :user => @user)
      @project.create_activity :create, owner: @user

      @project.update_attributes(:title => 'Act check1')
      @project.create_activity :update, owner: @user

      @project.update_attributes(:title => 'Act check2')
      @project.create_activity :update, owner: @user

      @project.update_attributes(:title => 'Act check3')
      @project.create_activity :update, owner: @user

      @project.update_attributes(:title => 'Act check4')
      @project.create_activity :update, owner: @user

      @del_act = DeleteActivities.new( @project )

      @del_act.del_1_day_ago_updates

    end

    subject { @del_act }

    specify { subject.one_day_ago_updates.size.should == 0 }
    
  end

end