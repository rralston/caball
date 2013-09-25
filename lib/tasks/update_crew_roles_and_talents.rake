

namespace :roles  do
  # used to update the database when the third level of crew roles and removed
  # and the second level is added as the super roles.
  task :update_crew => :environment do
    Role.where(:name => 'Crew').each do |role|
      role.update_attributes(:name => role.subrole, :subrole => role.super_subrole)
      puts "updated role #-#{role.id}"
    end

    Talent.where(:name => 'Crew').each do |talent|
      talent.update_attributes(:name => talent.sub_talent, :sub_talent => talent.super_sub_talent)
      puts "updated talent #-#{talent.id}"
    end
  end
end
