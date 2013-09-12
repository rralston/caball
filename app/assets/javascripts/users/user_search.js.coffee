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

	$('body').on 'click', 'input[name=roles]', (event)->
		
		switch $(this).val()
			# add more when clauses here if required in future.
			when 'Cast'
				if $(this).is(':checked')
					# show the extra options for search
					$(".cast-extn").show(1000)
				else
					# find teh checked ones and uncheck those before hiding. 
					$(".cast-extn").find(':checked').each () ->
						$(this).removeAttr('checked')
					$(".cast-extn").hide(1000)


