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
    @project_with_roles = FactoryGirl.create(:project, :roles => @roles, :title => 'with roles')
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
    before(:all){
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)
      @user4 = FactoryGirl.create(:user)
      role_application1  = FactoryGirl.create(:role_application, :approved => true, :role => @roles[1], :user => @user1)
      @roles[1].update_attributes(:filled => true)
      @role_application2  = FactoryGirl.create(:role_application, :approved => false, :role => @roles[1], :user => @user2)  
      @role_application3  = FactoryGirl.create(:role_application, :approved => false, :role => @roles[2], :user => @user3)  
      @role_application4  = FactoryGirl.create(:role_application, :approved => false, :role => @roles[2], :user => @user4)  
    }
    specify { @project_with_roles.participant_mails.split(', ').should =~ [@user1, @user2, @user3, @user4].map(&:email) }
    
    specify { @project_with_roles.pending_applications.should =~ [@role_application3, @role_application4] }
  end

  context "projects by friends and followers" do
    before(:all){
      @followed_user = FactoryGirl.create(:user)
      @following_user = FactoryGirl.create(:user)

      @friendship = FactoryGirl.create(:friendship, :user => @following_user, :friend => @followed_user)

      @followed_user_project = FactoryGirl.create(:project, :user => @followed_user)
      @following_user_project = FactoryGirl.create(:project, :user => @following_user)
    }

    specify { Project.projects_by_followers(@followed_user).should =~[@following_user_project] }
    specify { Project.projects_by_friends(@following_user).should =~[@followed_user_project] }
  end

  context "featured_projects" do
    let!(:featured_project1) { FactoryGirl.create(:project, :featured => true) }
    let!(:featured_project2) { FactoryGirl.create(:project, :featured => false) }
    let!(:featured_project3) { FactoryGirl.create(:project, :featured => true) }

    specify { Project.featured_projects.should =~ [featured_project1, featured_project3] }
    specify { Project.order_by_featured([featured_project3, featured_project2, featured_project1]).first(2).should =~ [featured_project1, featured_project3] }
  end

  context "ordering methods" do
    before(:all){
      @project1 = FactoryGirl.create(:project, :fans => [FactoryGirl.create(:user), FactoryGirl.create(:user)])
      
      @project2 = FactoryGirl.create(:project, :featured => false)
      
      @project3 = FactoryGirl.create(:project, :fans => [FactoryGirl.create(:user)])
    }

    specify { Project.order_by_new([@project1, @project3, @project2]).should == [@project1, @project2, @project3] }

    specify { Project.order_by_popularity([@project2, @project1, @project3]).should == [@project1, @project3, @project2] }
  end

  context "search project" do
    let!(:roles) {
      [
        FactoryGirl.create(:role, :name => 'role1'),
        FactoryGirl.create(:role, :name => 'role2'),
        FactoryGirl.create(:role, :name => 'role3'),
        FactoryGirl.create(:role, :name => 'role4'),
        FactoryGirl.create(:role, :name => 'role5'),
        FactoryGirl.create(:role, :name => 'role6'),
        FactoryGirl.create(:role, :name => 'role7'),
        FactoryGirl.create(:role, :name => 'role1'),
        FactoryGirl.create(:role, :name => 'role2'),
        FactoryGirl.create(:role, :name => 'role3')
      ]
    }
    let!(:roles_project_1) { FactoryGirl.create(:project, :roles => roles ) }
    let!(:roles_project_2) { FactoryGirl.create(:project, :roles => roles[7..9] ) }

    specify { Project.search_with_roles(roles[0..6].map(&:name)).should == [roles_project_1] }
    specify { roles_project_2.super_roles_needed.should =~ ['role1', 'role2', 'role3'] }
  end

  context "recent projects" do
    before(:all){
      sleep 1
      @first = FactoryGirl.create(:project, :title => '1')
      sleep 1
      @second = FactoryGirl.create(:project, :title => '2')
      sleep 1
      @third = FactoryGirl.create(:project, :title => '3')
    }

    specify { Project.recent_projects(1, 1).should == [@third] }
    specify { Project.recent_projects.first(3).should == [@first, @second, @third].reverse }
    
  end

end
