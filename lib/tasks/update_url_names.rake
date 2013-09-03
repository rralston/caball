require 'action_view/helpers'

extend ActionView::Helpers


namespace :caball  do
  task :update_url_names => :environment do

    puts "Updating Users"
    User.where(:url_name => nil).each  do |user|
      # if the name is changed, convert to the url name
      user.url_name = user.name.gsub(/\s/,'-').downcase

      # check  and get size of if any other users having the same url_name
      same_named_count = User.where("lower(url_name) = lower(?)", user.url_name).size
      if same_named_count > 0
        # append the count + 1 after the url_name.
        user.url_name = user.url_name + "-#{same_named_count.to_i + 1}"
      end
      puts "updated user - ##{user.id} - #{user.name} with #{user.url_name}"
    end


    puts "Updating Projects"
    Project.where(:url_name => nil).each  do |project|
      # if the name is changed, convert to the url name
      new_title = truncate(project.title, :length => 20, :separator => ' ', :omission => '')
      # if the name is changed, convert to the url name
      project.url_name = new_title.gsub(/\s/,'-').downcase

      # check  and get size of if any other projects having the same url_name
      same_named_count = Project.where("lower(url_name) = lower(?)", project.url_name).size
      if same_named_count > 0
        # append the count + 1 after the url_name.
        project.url_name = project.url_name + "-#{same_named_count.to_i + 1}"
      end

      puts "updated project - ##{project.id} - #{project.title} with #{project.url_name}"
    end


    puts "Updating Events"
    Event.where(:url_name => nil).each  do |event|
      # if the name is changed, convert to the url name
      new_title = truncate(event.title, :length => 20, :separator => ' ', :omission => '')
      # if the name is changed, convert to the url name
      event.url_name = new_title.gsub(/\s/,'-').downcase

      # check  and get size of if any other events having the same url_name
      same_named_count = Event.where("lower(url_name) = lower(?)", event.url_name).size
      if same_named_count > 0
        # append the count + 1 after the url_name.
        event.url_name = event.url_name + "-#{same_named_count.to_i + 1}"
      end

      puts "updated event - ##{event.id} - #{event.title} with #{event.url_name}"
    end
  end
end