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
    it { should have_many(:talents).dependent(:destroy) }
    it { should have_many(:friendships) }
    it { should have_many(:friends).through(:friendships) }
    it { should have_many(:comments) }
    it { should have_many(:blogs).dependent(:destroy) }

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

  context "Profile Pic" do
    context "When a profile pic exists, it shoudl return the medium version of it" do
      before(:all){
        @user = FactoryGirl.create(:user)
        @profile = FactoryGirl.create(:profile, :image => File.open(File.join(Rails.root, '/spec/fixtures/images/apple.jpeg')))
        @user.profile = @profile
        @user.save
      }
      subject { @user }

      its(:profile_pic) { should eql(@profile.image.url(:medium)) }

      after(:all){
        clean_local_uploads
      }
    end
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

end