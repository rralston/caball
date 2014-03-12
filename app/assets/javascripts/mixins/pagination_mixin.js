Filmzu._PaginatedRouteMixin = Ember.Mixin.create({
    paginationRoute: Ember.required(String),

// This function is for use in a route that calls find() to get a
// paginated collection of records. It takes the pagination metadata
// from the store and puts it into the record array.
    _includePagination: function(records){
        var metadata = records.store.typeMapFor(records.type).metadata;
        console.log(metadata, metadata.pagination)
// put the pagination content directly on the collection
        records.set('pagination', metadata.pagination);
        return records;
    },

    actions: {
        gotoPage: function(pageNum){
            var last = this.get('controller.content.pagination.total_pages') || 1;
            var num;
            if(pageNum > last){
                num = last;
            }else{
                num = pageNum
            }
//            = Util.clamp(pageNum, 1, last);
            this.transitionTo(this.paginationRoute, num);
        },
        nextPage: function(){
            var cur = parseInt(this.get('controller.content.pagination.current_page') || 0);
            this.transitionTo(this.paginationRoute, cur + 1);
        },
        previousPage: function(){
            var cur = parseInt(this.get('controller.content.pagination.current_page') || 2);
            this.transitionTo(this.paginationRoute, cur - 1);
        },
        lastPage: function(){
            var last = parseInt(this.get('controller.content.pagination.total_pages') || 1);
            this.transitionTo(this.paginationRoute, last);
        },
        firstPage: function(){
            this.transitionTo(this.paginationRoute, 1);
        }
    }

});