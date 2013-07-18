require 'spec_helper'
require 'request_helper'

describe User do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should have_one(:characteristics).dependent(:destroy) }
    it { should have_one(:profile).dependent(:destroy) }
    it { should have_many(:photos).dependent(:destroy) }
    it { should have_many(:videos).dependent(:destroy) }
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:talents).dependent(:destroy) }
    it { should have_many(:friendships) }
    it { should have_many(:friends).through(:friendships) }
    it { should have_many(:comments) }
    it { should have_many(:blogs).dependent(:destroy) }
    it { should have_many(:role_applications).dependent(:destroy) }
    it { should have_many(:sent_endorsements).dependent(:destroy) }
    it { should have_many(:received_endorsements).dependent(:destroy) }

    it { should accept_nested_attributes_for :profile }
    it { should accept_nested_attributes_for :characteristics }
    it { should accept_nested_attributes_for :photos }
    it { should accept_nested_attributes_for :videos }
    it { should accept_nested_attributes_for :projects }
    it { should accept_nested_attributes_for :talents }
  end

  context "Validations" do
    before(:all){
      @user = User.new
      @user.valid?
    }
    specify { @user.errors.full_messages.join(', ').should == 'Name is required, Name is required, Email is required, Email is required' }
  end

  context "Should create user when called with OmniAuth response hash" do
    before(:all){
      @auth = OmniAuth.config.mock_auth[:facebook]
      @user = User.from_omniauth(@auth)
    }

    subject { @user }

    its(:name) { should == @auth.info.name }
    its(:email) { should == @auth.info.email }
    its(:uid) { should == @auth.uid }
    its(:provider) { should == @auth.provider }
    its(:oauth_token) { should == @auth.credentials.token }
    its(:oauth_expires_at) { should == Time.at(@auth.credentials.expires_at) }

    specify { User.last.should == @user }
  end

  context "mailboxer_email of the user" do
    let(:user) { FactoryGirl.create(:user) }
    subject { user }

    specify { subject.mailboxer_email(nil).should eql(subject.email) }
  end

  context "experience" do
    let(:user) { FactoryGirl.create(:user) }
    let(:talent) { FactoryGirl.create(:talent, :experience => User.experience['0-2 year(s)']) }
    before { user.talents.push(talent) }

    it { user.talents.first.experience.should == User.experience['0-2 year(s)'] }
  end

  context "Profile Pic" do
    context "When a profile pic exists, it shoudl return the medium version of it" do
      before(:all){
        @user = FactoryGirl.create(:user)
        @profile = FactoryGirl.create(:profile, :image => File.open(File.join(Rails.root, '/spec/fixtures/images/apple.jpeg')))

        @photo = FactoryGirl.create(:photo, :image => File.open(File.join(Rails.root, '/spec/fixtures/images/apple.jpeg')))
        @user2= FactoryGirl.create(:user, :photos => [@photo])

        @user3 = FactoryGirl.create(:user)

        @user.profile = @profile
        @user.save
      }

      
      specify { @user.profile_pic.should eql(@profile.image.url(:medium)) }
      specify { @user2.profile_pic.should eql(@photo.image.url(:medium)) }
      specify { @user3.profile_pic.should eql('/assets/actor.png') }


      after(:all){
        clean_local_uploads
      }
    end
  end

  context "to json should include profile pic" do
    before(:all) do
      @photo = FactoryGirl.create(:photo, :image => File.open(File.join(Rails.root, '/spec/fixtures/images/apple.jpeg')))
      @user= FactoryGirl.create(:user, :photos => [@photo])
    end
    specify { @user.to_json().should include('profile_pic') }
  end

  context "details complete" do
    context "location is present" do
      let(:user) { FactoryGirl.create(:user, location: "Some-place") }
      it "should return true" do
        user.details_complete?.should == true
      end
    end
    context "location is not present" do
      let(:user) { FactoryGirl.create(:user, location: nil) }
      it "should return false" do
        user.details_complete?.should == false
      end
    end
  end

  context "returns a array of talent names" do
    before(:all){
      @talents = [
        FactoryGirl.create(:talent, :name => 'talent1'),
        FactoryGirl.create(:talent, :name => 'talent1'),
        FactoryGirl.create(:talent, :name => 'talent2')
      ]
      @user = FactoryGirl.create(:user, :talents => @talents)
    }
    subject { @user }
    its(:talent_names) { should =~ @talents.map(&:name).uniq }
  end

  context "recommendations" do
    before(:all){
      @owner_talents = [
        FactoryGirl.create(:talent, :name => 'Lighting'),
        FactoryGirl.create(:talent, :name => 'talent1'),
        FactoryGirl.create(:talent, :name => 'Other')
      ]
      @project_owner = FactoryGirl.create(:user, :talents => @owner_talents)
      @roles = [
        FactoryGirl.create(:role, :name => "Actor", :filled => true),
        FactoryGirl.create(:role, :name => "Lighting", :filled => false),
        FactoryGirl.create(:role, :name => "Actor", :filled => true),
        FactoryGirl.create(:role, :name => "Lighting", :filled => false),
        FactoryGirl.create(:role, :name => "Other", :filled => false)
      ]
      @project_1 = FactoryGirl.create(:project, :roles => @roles[0..1], :user => @project_owner)
      @project_2 = FactoryGirl.create(:project, :roles => @roles[2..4], :user => @project_owner)
    }

    context "gives all required role's names array " do
      specify { @project_owner.roles_required.should =~ @roles.select{|role| !role.filled}.map(&:name).uniq! }  
    end

    context "recommended people" do
      before(:all){
        @required_talents = @roles.select{|role| !role.filled}.map(&:name).uniq!.map { |role_name|
          FactoryGirl.create(:talent, :name => role_name)
        }
        @user_1 = FactoryGirl.create(:user, :talents => [@required_talents[0]]) 
        @user_2 = FactoryGirl.create(:user, :talents => [@required_talents[1]])
      }
      specify { @project_owner.recommended_people.should =~ [@user_1, @user_2] }
    end

    context "recommended projects" do
      before(:all){
        @project_1 = FactoryGirl.create(:project, :roles => [
          FactoryGirl.create(:role, :name => @owner_talents[0].name, :filled => false),
          FactoryGirl.create(:role, :name => @owner_talents[1].name, :filled => true)
        ])
        @project_2 = FactoryGirl.create(:project, :roles => [
          FactoryGirl.create(:role, :name => @owner_talents[0].name, :filled => false),
          FactoryGirl.create(:role, :name => @owner_talents[2].name, :filled => false)
        ])
        @project_3 = FactoryGirl.create(:project, :roles => [
          FactoryGirl.create(:role, :name => @owner_talents[0].name, :filled => true),
          FactoryGirl.create(:role, :name => @owner_talents[2].name, :filled => true)
        ])
      }
      subject { @project_owner }
      its(:recommended_projects) { should include(@project_1, @project_2) }
    end
  end

  context "activities feed" do
    before(:all){
      @project_owner = FactoryGirl.create(:user)
      @roles = [
        FactoryGirl.create(:role, :name => "Actor", :filled => true),
        FactoryGirl.create(:role, :name => "Lighting", :filled => false),
        FactoryGirl.create(:role, :name => "Actor", :filled => true),
        FactoryGirl.create(:role, :name => "Lighting", :filled => false),
        FactoryGirl.create(:role, :name => "Other", :filled => false)
      ]
      @project_1 = FactoryGirl.create(:project, :roles => @roles[0..1], :user => @project_owner)
      @friend = FactoryGirl.create(:user, :friends => [@project_owner])
      @owner_blog1 = FactoryGirl.create(:blog, :content => 'test blog', :user => @project_owner)
      @activity_1 = Activity.last.update_attributes(:owner => @project_owner)
      @act_with_receipt = FactoryGirl.create(:role_application).create_activity action: 'create', recipient: @friend, owner: @project_owner
    }

    specify { @friend.friends_activities.map(&:trackable).should include(@owner_blog1) }
    specify { @friend.friends_activities.map(&:id).should_not include(@act_with_receipt.id) }

    specify { @friend.addressed_activities.map(&:trackable).should_not include(@owner_blog1) }
    specify { @friend.addressed_activities.map(&:id).should include(@act_with_receipt.id) }  

    specify { @friend.activities_feed.should =~ [@friend.friends_activities, @friend.addressed_activities].flatten }  
    
  end

  context 'user following another user' do
    before(:all){
      @followed_user = FactoryGirl.create(:user)
      @follower1 = FactoryGirl.create(:user, :friendships => [FactoryGirl.create(:friendship, :friend => @followed_user)])
      @follower2 = FactoryGirl.create(:user, :friendships => [FactoryGirl.create(:friendship, :friend => @followed_user)])
    }

    specify { @followed_user.followers.should =~ [@follower2, @follower1] }

  end

end