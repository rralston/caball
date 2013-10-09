class UserRolesValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:roles] << ': Atleast one has to be selected.' if record.talents.size < 1

    record.errors[:roles] << ': Select no more than two roles.' if record.talents.size > 2   
  end

end