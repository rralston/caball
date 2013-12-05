class Activity < PublicActivity::Activity

def user
  User.find(trackable.user)
end

# def serializable_hash(options)
#   hash = super(options)
#   extra_hash = {
#     'trackable' => trackable
#   }
#   hash.merge!(extra_hash)
# end

def as_json(options)
  json = super(options)
  json['trackable'] = trackable
 
  if options[:check_user].present? and trackable.present?
    # likes and comments count is needed in dashboard
    if trackable_type == 'Event' or trackable_type == 'Project'
      json['trackable'][:user_liked] = trackable.likes.pluck("user_id").include?(options[:check_user].id)
      json['trackable'][:likes_count] = trackable.likes.count
      json['trackable'][:comments_count] = trackable.comments.count
    elsif trackable_type == 'Comment' or trackable_type == 'Blog'
      json['trackable'][:user_liked] = trackable.likes.pluck("user_id").include?(options[:check_user].id)
      json['trackable'][:likes_count] = trackable.likes.count
    end
  end


  json
end

end
