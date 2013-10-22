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

  context "applications" do

    before(:all) do
      @role = FactoryGirl.create(:role, :name => 'Actor', :subrole => 'Something')
      @project_owner = FactoryGirl.create(:user)
      @rejected_users = [
        FactoryGirl.create(:user, :role_applications => [FactoryGirl.create(:role_application, :role => @role)]),
        FactoryGirl.create(:user, :role_applications => [FactoryGirl.create(:role_application, :role => @role)]),
        FactoryGirl.create(:user, :role_applications => [FactoryGirl.create(:role_application, :role => @role)]),
        FactoryGirl.create(:user, :role_applications => [FactoryGirl.create(:role_application, :role => @role)])
      ]
      @approved_user = FactoryGirl.create(:user, :role_applications => [FactoryGirl.create(:role_application, :role => @role, :approved => true)])
      @role.update_attributes(:filled => true)
      
      @project_1 = FactoryGirl.create(:project, :roles => [@role], :user => @project_owner)
      
      @role.send_role_filled_messages
    end

    context "denied_applications" do
      specify { @role.rejected_users.should =~ @rejected_users }
      specify { @role.approved_user.should == @approved_user }

      specify { @rejected_users.sample.mailbox.inbox.map(&:subject).first.should == 'Regarding Role Application - Sorry' }
    end
  end

end