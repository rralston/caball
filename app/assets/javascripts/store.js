Filmzu.AuthenticatedRESTAdapter = DS.RESTAdapter.extend({
    namespace: 'api/v1',
    headers: {
        'Authorization': 'Token '+ $('#film_zu_container').attr('data-user-token')
    }
});

Filmzu.ApplicationAdapter = Filmzu.AuthenticatedRESTAdapter