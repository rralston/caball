class UserLocationValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:location] << ': Please enter your location.' if record.persisted? and record.location == "" || record.location == nil 
  end

end