$(document).ready ()-> 
  $('#expertise_tags').tagit
    sortable: true
    tagsChanged: (tagValue, action, element) ->
      tag_value_array = _.map($('#expertise_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_expertise').val(tag_value_array.toString())

  $('#user_description_tags').tagit
    sortable: true
    initialTags: []
    tagsChanged: (tagValue, action, element) ->
      tags_array = _.map($('#user_description_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_characteristics_attributes_description_tag_list').val(tags_array.toString())