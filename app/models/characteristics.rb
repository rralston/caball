class Characteristics < ActiveRecord::Base
  belongs_to :user

  acts_as_taggable_on :description_tag
  
  attr_accessible :age, :height, :ethnicity, :bodytype,
                  :hair_color, :description_tag_list, :language


  


  # tells if the characteristics are completely provided
  def completeness_sum
    # get the column names for which the completeness has to be checked.
    check_columns = Characteristics.column_names - ["id", "user_id", "language", "created_at", "updated_at"]
    
    # calculate the sum of properties that are present.
    present_sum = check_columns.map { |prop|
      self.send(prop).present? ? 1 : 0
    }.reduce(:+)

    # return number of properties that are present.
    present_sum
  end

  def self.clear_empty cast_hash
    cast_hash.each do |key, value|
      if value.kind_of?(Array)
        cast_hash[key].delete('')
      end
    end
  end

  def self.heights
    {
      "Not Applicable" => "Not Applicable",
      "Really short"   => "Really short",
      "Short"          => "Short",
      "Average"        => "Average",
      "Tall"           => "Tall",
      "Really tall"    => "Really tall"
    }
  end

  def self.ages
    {
      "Not Applicable" => "Not Applicable",
      "Kid"            => "Kid",
      "Teen"           => "Teen",
      "Young Adult"    => "Young Adult",
      "Adult"          => "Adult",
      "Parent"         => "Parent",
      "Golden Years"   => "Golden Years"
    }
    
  end

  def self.enthnicities
    {
      "Not Applicable"            => "Not Applicable",
      "Asian"                     => "Asian",
      "African American/Black"    => "African American/Black",
      "Caucasian"                 => "Caucasian",
      "Pacific Islander"          => "Pacific Islander",
      "Latino/ Hispanic/ Spanish" => "Latino/ Hispanic/ Spanish",
      "Middle Eastern"            => "Middle Eastern",
      "East Indian"               => "East Indian",
      "Native American"           => "Native American",
      "Other"                     => "Other"
    }
  end

  def self.bodytypes
    {
      "Not Applicable"       => "Not Applicable",
      "Lean/Petite"          => 'Lean/Petite',
      "Athletic/Toned"       => 'Athletic/Toned',
      "Average"              => 'Average',
      "Ripped/ Body Builder" => 'Ripped/ Body Builder',
      "Plus sized/Husky"     => 'Plus sized/Husky',
      "Large and in charge"  => 'Large and in charge'
    }
  end

  def self.hair_colors
    {
      "Not Applicable" => "Not Applicable",
      "Brown"          => "Brown",
      "Blonde"         => "Blonde",
      "Black"          => "Black",
      "Red"            => "Red",
      "Grey"           => "Grey",
      "Bald"           => "Bald",
      "Other"          => "Other"
    }
  end

  def self.languages
    {
      "Not Applicable" => "Not Applicable",
      'English'        => 'English',
      'Spanish'        => 'Spanish',
      'French'         => 'French',
      'German'         => 'German',
      'Italian'        => 'Italian'
    }
  end



end