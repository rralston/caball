require 'spec_helper'
require 'request_helper'

describe Event do
  before(:all) do
    clean!
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:other_photos).dependent(:destroy) }
    it { should have_many(:videos).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:other_important_dates).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:fans) }  

    it { should have_one(:main_photo).class_name('Photo').dependent(:destroy) }
    it { should have_one(:start).class_name('ImportantDate').dependent(:destroy) }
    it { should have_one(:end).class_name('ImportantDate').dependent(:destroy) }

    it { should accept_nested_attributes_for :other_photos }
    it { should accept_nested_attributes_for :videos }
    it { should accept_nested_attributes_for :main_photo }
    it { should accept_nested_attributes_for :start }
    it { should accept_nested_attributes_for :end }
    it { should accept_nested_attributes_for :other_important_dates }
  end

  context "Validations" do
    before(:all){
      @event = Event.new
      @event.valid?
    }
    specify { @event.errors.full_messages.join(', ').should == 'Title is required, Title is required, Description is required, Description is required' }
  end

  context "attending event" do
    before(:all){
      @att_1 = FactoryGirl.create(:user)
      @att_2 = FactoryGirl.create(:user)

      @event = FactoryGirl.create(:event)

      @att1 = FactoryGirl.create(:attend, :user => @att_1)
      @att2 = FactoryGirl.create(:attend, :user => @att_2)
      @event.attends << [@att1, @att2]
    }

    context 'its should list are attendees' do
      specify { @event.attendees.should =~ [@att_1, @att_2] }
      specify { @event.attendees_emails.should =~ [@att_1.email, @att_2.email] }
    end

    context "its should tell if a user is attending the event" do
      specify { @event.attending?(@att_1).should be true }
      specify { @event.attending?(FactoryGirl.create(:user)).should be false }
    end
    
  end

  context "user liking an event" do
    before(:all){
      @user = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event)

      @like = FactoryGirl.create(:like, :loveable => @event, :user => @user)
      @like = FactoryGirl.create(:like, :loveable => @event, :user => @user2)
    }

    specify { @event.likers.should =~ [@user, @user2] }
    specify { @event.liked_by?(@user).should == true }
    specify { @event.liked_by?(FactoryGirl.create(:user)).should == false }
  end
end
