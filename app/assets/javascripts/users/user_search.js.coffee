$ ->
	$('.srchsect .expand').unbind('click').click (event) ->
		el = $(this)
		if el.hasClass("shrinked")
			el.next().animate
				height: "250px",
				duration: 2000
			el.removeClass("shrinked")
		else
			el.next().animate
				height: "0px",
				duration: 2000
			el.addClass("shrinked")
		event.stopPropagation()
		event.preventDefault()

	$('#Cast').unbind('click').click (event) ->
		if $(this).is(':checked')
			$(".cast-extn").show(1000)
		else
			$(".cast-extn").find(':checked').each () ->
				$(this).removeAttr('checked')
			$(".cast-extn").hide(1000)
