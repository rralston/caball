Filmzu.FilmmakersIndexRoute = Ember.Route.extend({
//    model: function(){
//        return this.store.find('filmmaker', {page: 1});
//    },
//    setupController: function(controller, model){
//        controller.set('model', model);
//    }
    redirect: function(){
        this.transitionTo('filmmakers.page', 1);
    }
});