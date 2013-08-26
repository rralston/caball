class Characteristics < ActiveRecord::Base
  belongs_to :user

  acts_as_taggable_on :description_tag
  
  attr_accessible :age, :height, :weight, :ethnicity, :bodytype, :skin_color,
                  :eye_color, :hair_color, :chest, :waist, :hips, :dress_size,
                  :description_tag_list, :language


  


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

  def self.heights
    {
      "4'0 - 4'04\""   => "4'0 - 4'04\"",
      "4'5\" - 4'9\""  => "4'5\" - 4'9\"",
      "5' - 5'04\""    => "5' - 5'04\"",
      "5'5\" - 5'09\"" => "5'5\" - 5'09\""
    }
    
  end

  def self.enthnicities
    {
      'Asian'            => 'Asian',
      'black/African'    => 'black/African',
      'descent'          => 'descent',
      'white'            => 'white',
      'pacific islander' => 'pacific islander',
      'latino/ Hispanic' => 'latino/ Hispanic',
      'Spanish'          => 'Spanish',
      'Middle Eastern'   => 'Middle Eastern',
      'East Indian'      => 'East Indian'
    }
  end

  def self.bodytypes
    {
      'lean'                 => 'lean',
      'athletic/toned'       => 'athletic/toned',
      'Ripped/ body builder' => 'Ripped/ body builder',
      'plus sized/husky'     => 'plus sized/husky',
      'large and in charge'  => 'large and in charge'
    }
  end

  def self.hair_colors
    {
      'brown'  => 'brown',
      'blonde' => 'blonde',
      'black'  => 'black',
      'red'    => 'red',
      'grey'   => 'grey',
      'other'  => 'other'
    }
  end

  def self.languages
    {
      'English' => 'English',
      'Spanish' => 'Spanish',
      'French'  => 'French',
      'German'  => 'German',
      'Italian' => 'Italian'
    }
  end



end