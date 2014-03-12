Filmzu.PersonView = Ember.View.extend({
    templateName: 'person',
    didInsertElement: function(){
        $('.member-description').each(function(i){
            len=$(this).text().length;
            if(len > 350)
            {
                $(this).text($(this).text().substr(0,350)+'...');
            }
        });
    }
});