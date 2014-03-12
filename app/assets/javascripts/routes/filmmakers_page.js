Filmzu.FilmmakersPageRoute = Ember.Route.extend(Filmzu._PaginatedRouteMixin, {
////    model: function(){
////        return this.store.find('filmmaker', {page: 1});
////    },
////    setupController: function(controller, model){
////        controller.set('model', model);
////    }
//    redirect: function(){
//        this.transitionTo('filmmakers.page', 1);
//    }
    paginationRoute: 'filmmakers.page',
    model: function(params){
        var query = { page: params.num };
        return this.store.find('filmmaker', query).then(this._includePagination);
    },
    setupController: function(controller, model){
        controller.set('model', model)
    }
});