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
    it { should have_many(:up_votes).dependent(:destroy) }
    it { should have_many(:down_votes).dependent(:destroy) }

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

  context "search events" do
    before(:all){
      # sleep is to make sure, they have different created_at times
      @event0 = FactoryGirl.create(:event, :title => 'bangalore event', :location => 'Delhi', 
                                    :attends => [
                                            FactoryGirl.create(:attend),
                                            FactoryGirl.create(:attend)
                                          ],
                                    :start => FactoryGirl.create(:important_date, :is_start_date => true, :date_time =>'2023-07-17 14:50'))
      sleep 1
      @event1 = FactoryGirl.create(:event, :title => 'mazing', :location => 'JayaNagar, Bangalore, IN',
                                    :start => FactoryGirl.create(:important_date, :is_start_date => true, :date_time =>'2023-07-17 14:00'))
      sleep 1
      @event2 = FactoryGirl.create(:event, :title => 'search me like this', :location => 'Indira Nagar, Bangalore, IN',
                                    :attends => [FactoryGirl.create(:attend)],
                                    :start => FactoryGirl.create(:important_date, :is_start_date => true, :date_time =>'2023-07-18 14:50'))
      sleep 1
      @event3 = FactoryGirl.create(:event, :title => 'Search me somehow', :location => 'Vellore, TamilNadu, IN')
      @event4 = FactoryGirl.create(:event, :title => 'searchme text', :location => 'Hyderabad, India')
    }

    specify { Event.in_location('bangalore').should =~ [ @event1, @event2 ] }
    specify { Event.in_location('632014').should =~ [ @event3 ] }

    specify { Event.with_keyword('search me').should =~ [ @event3, @event2 ] }

    specify { Event.search_all('bangalore').should =~ [ @event1, @event2, @event0 ] }
    specify { Event.search_all('search me').should =~ [ @event3, @event2 ] }

    specify { Event.search_all_with_pagination('bangalore', 1, 1).size.should == 1}

    specify { Event.search_new_events('bangalore').should == [@event0, @event1, @event2]  }
    specify { Event.search_new_events('bangalore', 2, 1).should == [@event1]  }

    specify { Event.search_popular_events('bangalore').should == [@event0, @event2, @event1]  }
    specify { Event.search_popular_events('bangalore', 2, 1).should == [@event2]  }

    specify { Event.search_events_order_by_date('bangalore').should == [@event2, @event0, @event1]  }
    specify { Event.search_events_order_by_date('bangalore', 2, 1).should == [@event0]  }
  end

  context "votes" do
    before(:all){
      @voted_event = FactoryGirl.create(:event)
      @up_voter = FactoryGirl.create(:user)
      @down_voter = FactoryGirl.create(:user)

      @non_voter = FactoryGirl.create(:user)

      @voted_event.up_vote(@up_voter)
      @voted_event.down_vote(@down_voter)

      @voted_event.save
    }
    subject { @voted_event }

    its(:up_voters) { should =~ [@up_voter] }
    its(:down_voters) { should =~ [@down_voter] }

    specify { subject.voted_by_user?(@up_voter).should == true }
    specify { subject.voted_by_user?(@non_voter).should == false }

    specify { subject.voted_type_by_user(@up_voter).should == 'up' }
    specify { subject.voted_type_by_user(@down_voter).should == 'down' }

    specify { subject.voted_type_by_user(@non_voter).should == nil }

    specify { subject.votes_count.should == 0 }
    
    context "vote up/down and vote the other way again" do
      # upvoter can down vote the event and down voter can up vote the event.
      before(:all){
        @voted_event.down_vote(@up_voter)
        @voted_event.up_vote(@down_voter)
      }
      
      specify{ subject.reload.up_voters.should =~ [@down_voter] }
      specify{ subject.reload.down_voters.should =~ [@up_voter] }


      specify { subject.voted_type_by_user(@up_voter).should == 'down' }
      specify { subject.voted_type_by_user(@down_voter).should == 'up' }
    end

  end

  context "valid videos" do
    before(:all){
      @video_event = FactoryGirl.create(:event, :videos => [
          FactoryGirl.create(:video, :url => 'http://www.youtube.com/watch?v=08cmmA22l0Y'),
          FactoryGirl.create(:video),
          FactoryGirl.create(:video)
        ])
    }

    specify { @video_event.valid_videos.should == [@video_event.videos.first] }
      
  end

  context "url name" do
    before(:all){
      @event1 = FactoryGirl.create(:event, :title => 'Event With Name')
      @event2 = FactoryGirl.create(:event, :title => 'Event With Name')
      ap @event1.url_name
      ap @event2.url_name
    }

    specify { @event1.url_name.should == 'event-with-name' }
    specify { @event2.url_name.should == 'event-with-name' + "-2" }
  end


end
