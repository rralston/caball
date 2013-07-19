class Activity < PublicActivity::Activity

def user
  User.find(trackable.user)
end

def serializable_hash(options)
  hash = super(options)
  extra_hash = {
    'trackable' => trackable
  }
  hash.merge!(extra_hash)
end

end
