Filmzu.PersonRoute = Ember.Route.extend({
    model: function(params){
        return this.store.find('person', params.person_id);
    },
    setupController: function(controller, model){
        controller.set('model', model);
    }
});