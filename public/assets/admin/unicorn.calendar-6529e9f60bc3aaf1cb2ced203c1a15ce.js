$(document).ready(function(){unicorn.init(),$("#add-event-submit").click(function(){unicorn.add_event()}),$("#event-name").keypress(function(t){13==t.which&&unicorn.add_event()})}),unicorn={init:function(){var t=new Date;t.getDate(),t.getMonth(),t.getFullYear(),$("#fullcalendar").fullCalendar({header:{left:"prev,next",center:"title",right:"month,basicWeek,basicDay"},editable:!0,droppable:!0,drop:function(t,e){var i=$(this).data("eventObject"),n=$.extend({},i);n.start=t,n.allDay=e,$("#fullcalendar").fullCalendar("renderEvent",n,!0),$(this).remove()}}),this.external_events()},add_event:function(){if(""!=$("#event-name").val()){var t=$("#event-name").val();$("#external-events .panel-content").append('<div class="external-event ui-draggable label label-inverse">'+t+"</div>"),this.external_events(),$("#modal-add-event").modal("hide"),$("#event-name").val("")}else this.show_error()},external_events:function(){$("#external-events div.external-event").each(function(){var t={title:$.trim($(this).text())};$(this).data("eventObject",t),$(this).draggable({zIndex:999,revert:!0,revertDuration:0})})},show_error:function(){$("#modal-error").remove(),$('<div style="border-radius: 5px; top: 70px; font-size:14px; left: 50%; margin-left: -70px; position: absolute;width: 140px; background-color: #f00; text-align: center; padding: 5px; color: #ffffff;" id="modal-error">Enter event name!</div>').appendTo("#modal-add-event .modal-body"),$("#modal-error").delay("1500").fadeOut(700,function(){$(this).remove()})}};