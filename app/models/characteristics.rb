class Characteristics < ActiveRecord::Base
  belongs_to :user
  attr_accessible :age, :height, :weight, :ethnicity, :bodytype, :skin_color, :eye_color, :hair_color, :chest, :waist, :hips, :dress_size


  # tells if the characteristics are completely provided
  def completeness_sum
    # get the column names for which the completeness has to be checked.
    check_columns = Characteristics.column_names - ["id", "user_id", "created_at", "updated_at"]
    
    # calculate the sum of properties that are present.
    present_sum = check_columns.map { |prop|
      self.send(prop).present? ? 1 : 0
    }.reduce(:+)

    # return number of properties that are present.
    present_sum
  end

end