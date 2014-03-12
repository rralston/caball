Filmzu.Router.map(function() {
    this.resource('filmmakers');
    this.resource('person', {path: 'people/:person_id'})
});
