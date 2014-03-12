Filmzu.FilmmakersRoute = Ember.Route.extend({
    model: function(){
        return this.store.find('filmmaker');
    },
    setupController: function(controller, model){
        controller.set('model', model);
    }
});