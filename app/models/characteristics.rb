class Characteristics < ActiveRecord::Base
  belongs_to :user
  attr_accessible :age, :height, :weight, :ethnicity, :bodytype, :skin_color, :eye_color, :hair_color, :chest, :waist, :hips, :dress_size
end