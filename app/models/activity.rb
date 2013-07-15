class Activity < PublicActivity::Activity

def user
  User.find(trackable.user)
end

end
