app.collections.blogs = Backbone.Collection.extend
  model: app.models.blog
  
  video_sorted: ()->
    sorted = _.sortBy(this.models, (blog)->
      return blog.get('video').provider != null ? 0 : 1
    )
    sorted
  photo_sorted: ()->
    sorted = _.sortBy(this.models, (blog)->
      return blog.get('photo') != null ? 0 : 1
    )
    sorted
  text_sorted: ()->
    sorted = _.sortBy(this.models, (blog)->
      return (blog.get('video').provider == null && blog.get('photo') == null) ? 0 : 1
    )
    sorted
