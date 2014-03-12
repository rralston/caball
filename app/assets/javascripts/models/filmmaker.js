Filmzu.Filmmaker = DS.Model.extend({
    avatar: DS.attr('string'),
    name: DS.attr('string'),
    location: DS.attr('string'),
    role: DS.attr('string'),
    description: DS.attr('string')
});