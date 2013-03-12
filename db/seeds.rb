# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ryan = User.create! name: "Ryan", email: "ryan@gmail.com", location: "Auckland, New Zealand"
joe = User.create! name: "Joe", email: "joe@gmail.com", location: "San Francisco, CA, USA"
anne = User.create! name: "Anne", email: "anne@gmail.com", location: "Los Angeles, CA, USA"

