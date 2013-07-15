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

end
