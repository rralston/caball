$(document).ready ()-> 
  $('#expertise_tags').tagit
    sortable: true
    tagsChanged: (tagValue, action, element) ->
      console.log element
      tag_value_array = _.map($('#expertise_tags').tagit('tags'), (tag) ->
        tag.value
      )
      $('#user_expertise').val(tag_value_array.toString())