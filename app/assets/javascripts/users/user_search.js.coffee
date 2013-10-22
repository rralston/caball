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

		show_sub_role_options($(event.target))
		
		# to handle any extra options to show like height, ethnicity for Cast
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


	
	show_sub_role_options = (element) ->
		elem_wrapper = element.closest('.role_search_wrap')
		sub_type_div = elem_wrapper.find('.srchopt.sub_type')

		if sub_type_div.size() > 0
			# i.e., sub types exist.
			if element.is(':checked')
				sub_type_div.show(500)
			else
				sub_type_div.find(':checked').each () ->
					$(this).removeAttr('checked')
				sub_type_div.hide(500)

