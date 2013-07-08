def clean!(tables=false)
  # add the table names here whose data has to cleaned. 
  tables ||=  %w{ users profiles}
  ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS=0;")
  tables.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE #{table};")
  end
  ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS=1;")
end

def clean_local_uploads
  if Rails.env.test? || Rails.env.cucumber?
    FileUtils.rm_rf("#{Rails.root}/tmp/uploads/profile/.", secure: true)
  end
end