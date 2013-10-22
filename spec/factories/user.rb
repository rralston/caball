FactoryGirl.define do

  sequence :user_email do |n|
    domain = ['yahoo', 'gmail', 'rediffmail'].sample
    "email#{n}@#{domain}.com"
  end

  sequence :user_name do |n|
    "user#{n}"
  end

  factory :user do
    email { FactoryGirl.generate(:user_email) }
    name { FactoryGirl.generate(:user_name) }
    uid '1234567789'
    provider 'facebook'
    password 'pass1234'
    #password_confirmation 'pass1234'
  end

end