app.collections.blogs = Backbone.Collection.extend
  model: app.models.blog
  
  video_sorted: ()->
    _this = this
    sorted = _.sortBy(this.models, (blog)->
      return _this.video_present(blog) ? 0 : 1
    )
    sorted
  photo_sorted: ()->
    sorted = _.sortBy(this.models, (blog)->
      return blog.get('photo') != null ? 0 : 1
    )
    sorted
  text_sorted: ()->
    _this = this
    sorted = _.sortBy(this.models, (blog)->
      return ( _this.video_not_present(blog) && blog.get('photo') == null) ? 0 : 1
    )
    sorted

  video_present: (blog) ->
    return typeof blog.get('video') != 'undefined' && blog.get('video') != null && blog.get('video').provider != null

  video_not_present: (blog) ->
    return (typeof blog.get('video') == 'undefined' || blog.get('video') == null || blog.get('video').provider == null)