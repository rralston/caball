require 'spec_helper'
require 'request_helper'
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

end