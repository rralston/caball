class UserRolesValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors[:roles] << ': Atleast one has to be selected.' if record.persisted? and record.talents.size < 1

    if record.talents.size > 2
      to_add_talents = record.talents.select { |role|
        role['_destroy'] == false
      } 
      record.errors[:roles] << ': Select no more than two roles.' if record.persisted? and to_add_talents.size > 2         
    end

  end

end