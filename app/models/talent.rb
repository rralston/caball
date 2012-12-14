class Talent < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :description
end