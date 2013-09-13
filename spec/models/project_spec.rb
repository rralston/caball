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

  context "popular projects" do
    before(:all){
      @pop_project1 = FactoryGirl.create(:project)
      @pop_project2 = FactoryGirl.create(:project)
      @pop_project3 = FactoryGirl.create(:project)

      @likes = [
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project2.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project2.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project2.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project2.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project2.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project2.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project2.id, :user => FactoryGirl.create(:user)),
        
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project1.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project1.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project1.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project1.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project1.id, :user => FactoryGirl.create(:user)),
        
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project3.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project3.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project3.id, :user => FactoryGirl.create(:user)),
        FactoryGirl.create(:like, :loveable_type => 'Project', :loveable_id => @pop_project3.id, :user => FactoryGirl.create(:user))
      ]
    }

    specify { Project.popular_projects.first(3).should == [@pop_project2, @pop_project1, @pop_project3] }
  end

  context "search project" do
    before(:all){
      @roles =
        [
          FactoryGirl.create(:role, :name => 'cast'),
          FactoryGirl.create(:role, :name => 'role2'),
          FactoryGirl.create(:role, :name => 'role3'),
          FactoryGirl.create(:role, :name => 'role4'),
          FactoryGirl.create(:role, :name => 'role5'),
          FactoryGirl.create(:role, :name => 'role6'),
          FactoryGirl.create(:role, :name => 'role7'),
          FactoryGirl.create(:role, :name => 'role8'),
          FactoryGirl.create(:role, :name => 'role9'),
          FactoryGirl.create(:role, :name => 'role10')
        ]
      @roles_project_1 = FactoryGirl.create(:project, 
                                :title => 'im project',
                                :roles => [
                                    FactoryGirl.create(:role, :name => 'Cast', :height => 'tall', :ethnicity => 'asian'),
                                    FactoryGirl.create(:role, :name => 'Crew', :subrole => 'Light'),
                                    FactoryGirl.create(:role, :name => 'role2'),
                                    FactoryGirl.create(:role, :name => 'role3'),
                                    FactoryGirl.create(:role, :name => 'role4'),
                                    FactoryGirl.create(:role, :name => 'role5'),
                                    FactoryGirl.create(:role, :name => 'role6'),
                                  ],
                                :location => 'Hyderabad' 
                              )
      sleep 1
      @roles_project_2 = FactoryGirl.create(:project, 
                                :title => 'search me again',
                                :roles => [
                                    FactoryGirl.create(:role, :name => 'role3'),
                                    FactoryGirl.create(:role, :name => 'role4'),
                                    FactoryGirl.create(:role, :name => 'role5'),
                                    FactoryGirl.create(:role, :name => 'role6'),
                                    FactoryGirl.create(:role, :name => 'Cast', :height => 'tall', :ethnicity => 'asian'),
                                    FactoryGirl.create(:role, :name => 'Crew', :subrole => 'Sound')
                                  ],
                                :location => 'Bangalore',
                                :featured => true,
                                :likes => [
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like)
                                ]
                              )
      @roles_project_2.genre_list = 'action, adventure, comedy'
      @roles_project_2.is_type_list = 'romance, fiction'
      @roles_project_2.save
      sleep 1
      @roles_project_3 = FactoryGirl.create(:project, 
                                :title => 'search me',
                                :roles => [
                                    FactoryGirl.create(:role, :name => 'role5'),
                                    FactoryGirl.create(:role, :name => 'role6'),
                                    FactoryGirl.create(:role, :name => 'Cast', :height => 'short', :ethnicity => 'asian'),
                                    FactoryGirl.create(:role, :name => 'Crew', :subrole => 'Camera'),
                                  ],
                                :location => 'Bangalore',
                                :likes => [
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like),
                                  FactoryGirl.create(:like)
                                ]
                              )
      @roles_project_3.genre_list = 'action, adventure, thriller'
      @roles_project_3.is_type_list = 'scifi, fiction'
      @roles_project_3.save

      @cast_hash = {
        :height => 'tall',
        :ethnicity => 'asian'
      }

      @sub_roles_search_hash = {
        'Crew' => [
          'Light',
          'Sound'
        ]
      }
    }
      

    # specify { Project.search_with_roles(@roles[0..6].map(&:name)).should == [@roles_project_1] }
    # specify { @roles_project_2.super_roles_needed.should =~ ['cast', 'role2', 'role3'] }

    specify { 
      Project.search_all(nil, nil, ['Cast', 'Crew'], @sub_roles_search_hash, @cast_hash, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_1, @roles_project_2]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'Cast', 'Crew'], @sub_roles_search_hash, @cast_hash, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_1, @roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'Cast', 'Crew'], @sub_roles_search_hash, nil, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_1, @roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, nil, ['Cast', 'Crew'], nil, nil, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_1, @roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'Cast'], nil, @cast_hash, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_2, @roles_project_1, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'role6'], nil, nil, ['action'], ['fiction'], 'bangalore', nil, nil, 1, 3).
        should =~ [@roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'role6'], nil, nil, nil, nil, 'bangalore', 800, nil, 1, 3).
        should =~ [@roles_project_1, @roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, 'search', nil, nil, nil, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, 'search', ['role5', 'role6'], nil, nil, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, 'search', ['role5', 'role6'], nil, nil, ['adventure', 'thriller'], nil, nil, nil, nil, 1, 3).
        should == [@roles_project_3]
    }

    specify { 
      Project.search_all(nil, 'search', ['role5', 'role6'], nil, nil, ['adventure', 'action'], ['fiction', 'romance'], nil, nil, nil, 1, 3).
        should == [@roles_project_2]
    }

    specify { 
      Project.search_all(nil, nil , ['role4', 'role5', 'role6'], nil, nil, nil, nil, nil, nil, nil, 1, 3).
        should =~ [@roles_project_1, @roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'role6'], nil, nil, ['action'], ['fiction'], 'bangalore', nil, 'recent', 1, 3).
        should == [@roles_project_3, @roles_project_2]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'role6'], nil, nil, ['action'], ['fiction'], 'bangalore', nil, 'featured', 1, 3).
        should == [@roles_project_2, @roles_project_3]
    }

    specify { 
      Project.search_all(nil, nil, ['role5', 'role6'], nil, nil, ['action'], ['fiction'], 'bangalore', nil, 'popular', 1, 3).
        should == [@roles_project_2, @roles_project_3]
    }
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

  context "valid videos" do
    before(:all){
      @video_project = FactoryGirl.create(:project, :videos => [
          FactoryGirl.create(:video, :url => 'http://www.youtube.com/watch?v=08cmmA22l0Y'),
          FactoryGirl.create(:video),
          FactoryGirl.create(:video)
        ])
    }

    specify { @video_project.valid_videos.should == [@video_project.videos.first] }
      
  end

  context "url name" do
    before(:all){
      @project1 = FactoryGirl.create(:project, :title => 'Project With Name')
      @project2 = FactoryGirl.create(:project, :title => 'Project With Name')
      ap @project1.url_name
      ap @project2.url_name
    }

    specify { @project1.url_name.should == 'project-with-name' }
    specify { @project2.url_name.should == 'project-with-name' + "-2" }
  end

end
