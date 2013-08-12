namespace :votes  do
  task :update_values => :environment do
    Vote.all.each  do |vote|
      if vote.is_up_vote
        vote.update_attributes(:value => 1)
      else
        vote.update_attributes(:value => -1)
      end
    end
  end
end