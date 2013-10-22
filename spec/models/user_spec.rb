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
        FactoryGirl.create(:talent, :name => 'Other')
      ]
      @project_owner = FactoryGirl.create(:user, :talents => @owner_talents, :location => 'Bangalore')
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

        @user_1 = FactoryGirl.create(:user, :name => 'USer_1', :talents => [@required_talents[0]], :location => 'Bangalore') 
        @user_2 = FactoryGirl.create(:user, :name => 'User_2', :talents => [@required_talents[1]], :location => 'Indiranagar, Bangalore, India')

        @friend_1 = FactoryGirl.create(:user, :name => 'Friend_1', :talents => [@required_talents[1]], :location => 'Indiranagar, Bangalore, India')

        @project_owner.friends << @friend_1
        @project_owner.save

        @user_1.friends << @friend_1
        @user_1.save
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

  context "applied projects" do
    before{
      @role = FactoryGirl.create(:role, :name => 'Actor', :subrole => 'Something')
      @role2 = FactoryGirl.create(:role, :name => 'Actor', :subrole => 'Something')
      @project_owner = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project, :user => @project_owner, :roles => [@role])
      @project2 = FactoryGirl.create(:project, :user => @project_owner, :roles => [@role2])
      @applied_user = FactoryGirl.create(:user, :role_applications => [
                                                    FactoryGirl.create(:role_application, :role => @role),
                                                    FactoryGirl.create(:role_application, :role => @role2)
                                        ])
    }
      
    specify { @applied_user.applied_projects.should =~ [@project, @project2] }
  end

  context "attending events" do
    before(:all){
      @attending_user = FactoryGirl.create(:user)

      @event1 = FactoryGirl.create(:event)
      @event2 = FactoryGirl.create(:event)

      @att1 = FactoryGirl.create(:attend, :user => @attending_user)
      @att2 = FactoryGirl.create(:attend, :user => @attending_user)
      
      @event1.attends << [@att1]
      @event2.attends << [@att2]
    }

    specify { @attending_user.attending_events.should =~ [@event1, @event2] }
  end

  context "popular_users" do
    before(:all){
      clean!(%w{ friendships })
      @p_user_1 = FactoryGirl.create(:user, :name => "p_1")
      @p_user_2 = FactoryGirl.create(:user, :name => "p_2")
      @p_user_3 = FactoryGirl.create(:user, :name => "p_3")

      @follower_x = FactoryGirl.create(:user)

      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_1)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_1)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_1)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_1)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_1)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_1)

      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_2)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_2)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_2)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_2)

      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_3)
      FactoryGirl.create(:friendship, :user => @follower_x, :friend => @p_user_3)
    }

    specify { User.popular_users.should == [@p_user_1, @p_user_2, @p_user_3] }
    
  end

  context "search" do
    cast_hash = {
      :height => "",
      :ethnicity => "",
      :bodytype => "",
      :hair_color => "",
      :language => ""
    }
    asian_cast_hash = {
      :height => "",
      :ethnicity => "Asian",
      :bodytype => "",
      :hair_color => "",
      :language => ""
    }
    before(:all){
      @search_user1 = FactoryGirl.create(:user, :name => 'Search User', :location => 'Bangalore', :talents => [
          FactoryGirl.create(:talent, :name => 'Director'),
          FactoryGirl.create(:talent, :name => 'Writer')
        ])
      @search_user2 = FactoryGirl.create(:user, :name => 'Search user 2', :location => 'Indira Nagar, Bangalore', :talents => [
                                                                                                      FactoryGirl.create(:talent, :name => 'Director'),
                                                                                                      FactoryGirl.create(:talent, :name => 'Production'),
                                                                                                      FactoryGirl.create(:talent, :name => 'Cast')
                                                                                                    ])
      characteristics = FactoryGirl.create :characteristics, user: @search_user2
      @search_user3 = FactoryGirl.create(:user, :location => 'Hyderabad, Andhra Pradesh', :talents => [
          FactoryGirl.create(:talent, :name => 'Cast'),
          FactoryGirl.create(:talent, :name => 'Production', :sub_talent => 'Asst. Prod')
        ])

      @search_user4 = FactoryGirl.create(:user, :location => 'Mumbai, India', :talents => [
          FactoryGirl.create(:talent, :name => 'Fan'),
          FactoryGirl.create(:talent, :name => 'Crew', :sub_talent => 'Light')
        ])

      @search_user5 = FactoryGirl.create(:user, :location => 'Mumbai, India', :talents => [
          FactoryGirl.create(:talent, :name => 'Fan'),
          FactoryGirl.create(:talent, :name => 'Crew', :sub_talent => 'Sound')
        ])

      @search_user6 = FactoryGirl.create(:user, :location => 'Mumbai, India', :talents => [
          FactoryGirl.create(:talent, :name => 'Fan'),
          FactoryGirl.create(:talent, :name => 'Crew', :sub_talent => 'Camera')
        ])

      @search_user7 = FactoryGirl.create(:user, :location => 'Hyderabad, Andhra Pradesh', :name => 'pick', :talents => [
          FactoryGirl.create(:talent, :name => 'Fan'),
          FactoryGirl.create(:talent, :name => 'Agent', :sub_talent => 'Exec. Agent')
        ])

      @search_user8 = FactoryGirl.create(:user, :location => 'Hyderabad, Andhra Pradesh', :name => 'nopick', :talents => [
          FactoryGirl.create(:talent, :name => 'Fan'),
          FactoryGirl.create(:talent, :name => 'Agent', :sub_talent => 'Asst. Agent')
        ])

      @sub_talents_search_hash = {
        'Crew' => [
          'Light',
          'Sound'
        ],
        'Agent' => [
          'Exec. Agent'
        ]
      }

    }

    specify { User.filter_all(nil, 'search', nil, nil, ['Cast', 'Director'], nil, cast_hash, 1, 10).should == [@search_user1,@search_user2] }
    specify { User.filter_all(nil, 'search', nil, nil, [], nil, cast_hash).should =~ [@search_user2, @search_user1] }
    specify { User.filter_all(nil, '', nil, nil, ['Cast', 'Production'], nil, cast_hash).should =~ [@search_user2, @search_user3] }

    specify { User.filter_all(User.where(:id => [@search_user2.id, @search_user3.id]), '',nil, nil, ['Cast', 'Production'], nil, cast_hash).should =~ [@search_user2, @search_user3] }

    specify { User.filter_all(nil, nil, 'Bangalore', 700, ['Cast', 'Production'], nil, cast_hash).should == [@search_user2, @search_user3] }

    specify { User.filter_all(nil, '', nil, nil, ['Cast', 'Production'], nil, asian_cast_hash).should =~ [@search_user2] }

    specify { User.filter_all(nil, '', nil, nil, ['Cast', 'Crew'], @sub_talents_search_hash, cast_hash).should =~ [@search_user2, @search_user3, @search_user4, @search_user5, @search_user7] }

    specify { User.filter_all(nil, '', nil, nil, ['Cast', 'Crew'], @sub_talents_search_hash, cast_hash, nil, nil, @search_user7).should =~ [@search_user2, @search_user3, @search_user4, @search_user5] }
  end


  context "notifications" do
    before(:all){
      @notif_user = FactoryGirl.create(:user, :name => 'Notif user')
      @notif_project = FactoryGirl.create(:project, :user => @notif_user)
      @notif_event = FactoryGirl.create(:event, :user => @notif_user)

      @sender = FactoryGirl.create(:user, :name => 'sender')
      
      @p_comment1 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      sleep 1
      @p_comment2 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      sleep 1
      @p_comment3 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      sleep 1
      @p_comment4 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      sleep 1
      @p_comment5 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      sleep 1
      @p_comment6 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      sleep 1
      @p_comment7 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      
      @r1 = @sender.send_message(@notif_user, 'Test Body', 'Test Subject')
      
      check_time = Time.now()
      sleep 1
      @p_comment8 = FactoryGirl.create(:comment, :commentable_type => 'Project', :commentable_id => @notif_project.id)
      sleep 1
      
      @e_comment = FactoryGirl.create(:comment, :commentable_type => 'Event', :commentable_id => @notif_event.id)

      
      sleep 1
      @r2 = @sender.send_message(@notif_user, 'Test Body 2', 'Test Subject 2')

      old_notifications = @notif_user.unread_notifications

      # mark read until, @p_comment7
      @notif_user.update_attributes(:notification_check_time => check_time)

      notifications = @notif_user.unread_notifications

      @comments = notifications.select{ |notif| notif.class.name == "Activity" }
      @receipts = notifications.select{ |notif| notif.class.name == 'Receipt' }
    }

    specify { @comments.map(&:trackable).should == [@e_comment, @p_comment8] }
    specify { @receipts.map(&:message).should == [@r2.message] }
    
  end

  context "eligibility to apply for a role" do
    before(:all){
      @roled_user = FactoryGirl.create(:user, :talents => [FactoryGirl.create(:talent, :name => 'Actor'), FactoryGirl.create(:talent, :name => 'Costumes')])


      @eligible_role = FactoryGirl.create(:role, :name => 'Actor')
      @uneligible_role = FactoryGirl.create(:role, :name => 'Hair')
      
    }

    specify { @roled_user.can_apply_for?(@eligible_role).should == true }
    specify { @roled_user.can_apply_for?(@uneligible_role).should == false }
  end

  context "should tell if the user applied for the role" do
    before(:all){
      @roled_user = FactoryGirl.create(:user, :talents => [FactoryGirl.create(:talent, :name => 'Actor'), FactoryGirl.create(:talent, :name => 'Costumes')])

      @eligible_role = FactoryGirl.create(:role, :name => 'Actor')
      @uneligible_role = FactoryGirl.create(:role, :name => 'Hair')

      @roled_user.role_applications.create(:role_id => @eligible_role.id)
    }
    specify { @roled_user.has_applied?(@eligible_role).should == true }
    specify { @roled_user.can_apply_for?(@eligible_role).should == false }
    specify { @roled_user.can_apply_for?(@uneligible_role).should == false }
  end

  context "valid videos" do
    before(:all){
      @video_user = FactoryGirl.create(:user, :videos => [
          FactoryGirl.create(:video, :url => 'http://www.youtube.com/watch?v=08cmmA22l0Y'),
          FactoryGirl.create(:video),
          FactoryGirl.create(:video)
        ])
    }

    specify { @video_user.valid_videos.should == [@video_user.videos.first] }
      
  end


  context "completeness" do
    before(:all){
      @com_user1 = FactoryGirl.create(:user, :location => 'bangalore',
                                      :about => "nothing much",
                                      :gender => "male",
                                      :headline => 'headline',
                                      :expertise => 'skils',
                                      :imdb_url => 'http://something')
      @com_user2 = FactoryGirl.create(:user)
    }

    specify { @com_user1.completeness.should == 24 }
    specify { @com_user2.completeness.should == 0 }
  end

  context "url name" do
    before(:all){
      @user1 = FactoryGirl.create(:user, :name => 'Munna Vishnu')
      @user2 = FactoryGirl.create(:user, :name => 'Munna Vishnu')
      ap @user1.url_name
      ap @user2.url_name
    }

    specify { @user1.url_name.should == 'munna-vishnu' }
    specify { @user2.url_name.should == 'munna-vishnu' + "-2" }
  end

  context "validation of presence of talents" do
    before(:all){
      @no_talent_user = FactoryGirl.build(:user, :talents => [])
      @no_talent_user.valid?


      @more_talented_user = FactoryGirl.build(:user, :talents => [
          FactoryGirl.create(:talent, :name => 'Fan'),
          FactoryGirl.create(:talent, :name => 'Agent'),
          FactoryGirl.create(:talent, :name => 'Writer')
        ])

      @valid_user =  FactoryGirl.build(:user, :talents => [ FactoryGirl.create(:talent) ])
    }
    specify { @no_talent_user.valid?.should == false }
    specify { @no_talent_user.errors.full_messages.first.should == 'Roles : Atleast one has to be selected.' }

    specify { @more_talented_user.valid?.should == false }

    specify { @valid_user.valid?.should == true }
  end

end