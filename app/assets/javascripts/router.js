Filmzu.Router.map(function() {
    this.resource('filmmakers', {path: '/filmmakers'}, function(){
        this.route('page', {path: ':num'})
    });
    this.resource('person', {path: 'people/:person_id'})
});



//this.resource('messages', { path: '/messages'}, function(){
//    this.route('page', { path: ':num' });
//});