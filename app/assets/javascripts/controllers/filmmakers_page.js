Filmzu.FilmmakersPageController = Ember.ArrayController.extend({
    firstPage: function(){
        var current = this.get('content.pagination.current_page')
        if(current == 1){
            return true;
        }else{
            return false;
        }
    }.property('content.pagination.current_page'),
    lastPage: function(){
        var current = this.get('content.pagination.current_page');
        var last = this.get('content.pagination.total_pages');
        if(current == last){
            return true;
        }else{
            return false;
        }
    }.property('content.pagination.current_page')
});