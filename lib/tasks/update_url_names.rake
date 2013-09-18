require 'action_view/helpers'

extend ActionView::Helpers


def update_user(user)
  new_name = truncate(user.name, :length => 20, :separator => ' ', :omission => '')

  # if the name is changed, convert to the url name
  user.url_name = new_name.gsub(/\s/,'-').downcase
  user.raw_url_name = user.url_name
  # check  and get size of if any other users having the same url_name
  same_named_count = User.where("lower(raw_url_name) = lower(?)", user.url_name).size

  if same_named_count > 0
  # append the count + 1 after the url_name.
  user.url_name = user.url_name + "-#{same_named_count.to_i + 1}"
  end

  user.save

  puts "updated user - ##{user.id} - #{user.name} with #{user.url_name}"
end

def update_project(project)
  # if the name is changed, convert to the url name
      new_title = truncate(project.title, :length => 20, :separator => ' ', :omission => '')
      # if the name is changed, convert to the url name
      project.url_name = new_title.gsub(/\s/,'-').downcase
      project.raw_url_name = project.url_name
      # check  and get size of if any other projects having the same url_name
      same_named_count = Project.where("lower(raw_url_name) = lower(?)", project.url_name).size
      if same_named_count > 0
        # append the count + 1 after the url_name.
        project.url_name = project.url_name + "-#{same_named_count.to_i + 1}"
      end

      project.save

      puts "updated project - ##{project.id} - #{project.title} with #{project.url_name}"
end

def update_event(event)
  # if the name is changed, convert to the url name
      new_title = truncate(event.title, :length => 20, :separator => ' ', :omission => '')
      # if the name is changed, convert to the url name
      event.url_name = new_title.gsub(/\s/,'-').downcase
      event.raw_url_name = event.url_name
      # check  and get size of if any other events having the same url_name
      same_named_count = Event.where("lower(raw_url_name) = lower(?)", event.url_name).size
      if same_named_count > 0
        # append the count + 1 after the url_name.
        event.url_name = event.url_name + "-#{same_named_count.to_i + 1}"
      end

      event.save

      puts "updated event - ##{event.id} - #{event.title} with #{event.url_name}"
  
end

namespace :caball  do
  task :update_url_names => :environment do

    puts "Updating Users"
    
    User.where(:url_name => nil).each  do |user|
      update_user(user)
    end


    puts "Updating Projects"
    Project.where(:url_name => nil).each  do |project|
      update_project(project)
    end


    puts "Updating Events"
    Event.where(:url_name => nil).each  do |event|
      update_event(event)
    end
  end

  task :update_raw_url_names => :environment do

    puts "Updating Users"
    
    User.where(:raw_url_name => nil).each  do |user|
      update_user(user)
    end


    puts "Updating Projects"
    Project.where(:raw_url_name => nil).each  do |project|
      update_project(project)
    end


    puts "Updating Events"
    Event.where(:raw_url_name => nil).each  do |event|
      update_event(event)
    end
  end

end