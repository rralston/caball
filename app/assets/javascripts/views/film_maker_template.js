Filmzu.FilmMakerTemplateView = Ember.View.extend({
    templateName: 'filmmaker'
});
//
//
//
//
//
//    ExperfyProposal.MilestoneView = Ember.View.extend({
//        templateName: 'milestone',
//        actions: {
//            delete: function(){
//                this.get("content").deleteRecord()
//                this.get("content").save()
//            }
//        },
//        amount_total: function(){
//            return "$ "+ (this.get("content").get("amount")*1.2).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,")
//        }.property("content.amount"),
//        delivery_date_format: function(){
//            var date=this.get("content").get("delivery_date")
//            if (date)
//                return moment(this.get("content").get("delivery_date")).format("MMMM DD, YYYY")
//            else
//                return 0;
//        }.property("content.delivery_date")
//    });
//
