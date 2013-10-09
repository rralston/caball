class UserRolesValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:roles] << ': Atleast one has to be selected.' if record.talents.size < 1
  end

end