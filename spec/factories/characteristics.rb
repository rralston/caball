FactoryGirl.define do
  
  factory :characteristics do
  	user {build_stubbed :user}
  	height "4'0 - 4'04\""
  	ethnicity 'Asian' 
    bodytype 'lean'
    hair_color 'brown'
    language 'English'
  end
  
end