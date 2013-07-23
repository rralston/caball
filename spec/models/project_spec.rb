require 'spec_helper'
require 'request_helper'

describe Project do
  before(:all) do
    clean!
    @roles = [
      FactoryGirl.create(:role, :filled => true),
      FactoryGirl.create(:role),
      FactoryGirl.create(:role)
    ]
    @project_with_roles = FactoryGirl.create(:project, :roles => @roles)
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:roles).dependent(:destroy) }
    it { should have_many(:photos).dependent(:destroy) }
    it { should have_many(:videos).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:project_dates).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:fans) }
    
    it { should accept_nested_attributes_for :roles }
    it { should accept_nested_attributes_for :photos }
    it { should accept_nested_attributes_for :videos }
    it { should accept_nested_attributes_for :project_dates }
  end

  context "Validations" do
    before(:all){
      @project = Project.new
      @project.valid?
    }
    specify { @project.errors.full_messages.join(', ').should == 'Title is required, Title is required, Description is required, Description is required' }
  end

  context "filled roled" do
    before{
      # just to make sure. line no 71 might be executed first
      @roles[1].update_attributes(:filled => false)
    }
    subject { @project_with_roles }
    its(:filled_roles) { should =~ [@roles[0]] }
  end

  context "roles percent" do
    context "when roles present, return percentage" do
      before(:all){
        
      }
      subject { @project_with_roles }
      its(:roles_percent) { should == ((1.0/3.0)*10).to_i }
    end

    context "when no roles are present" do
      subject { FactoryGirl.create(:project) }
      its(:roles_percent) { should == 10 }
    end
  end

  context "Open rules" do
    subject { @project_with_roles }
    its(:open_roles) { should =~ @roles[1..2] }
  end

  context "applications" do
    before{
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)
      @user4 = FactoryGirl.create(:user)
      role_application1  = FactoryGirl.create(:role_application, :approved => true, :role => @roles[1], :user => @user1, :user => @user)
      @roles[1].update_attributes(:filled => true)
      role_application2  = FactoryGirl.create(:role_application, :approved => false, :role => @roles[1], :user => @user2)  
      @role_application3  = FactoryGirl.create(:role_application, :approved => false, :role => @roles[2], :user => @user3)  
      @role_application4  = FactoryGirl.create(:role_application, :approved => false, :role => @roles[2], :user => @user4)  
    }
    specify { @project.paricipant_mails.should == [@user1, @user2, @user3, @user4].map(&:email) }
    specify { @project_with_roles.pending_applications.should =~ [@role_application3, @role_application4] }
  end

end
