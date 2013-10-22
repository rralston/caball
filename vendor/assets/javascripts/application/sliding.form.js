$(function() {
	/*
	number of fieldsets
	*/
	var fieldsetCount = $('#formElem fieldset').length; 
	/*
	current position of fieldset / navigation link
	*/
	var current 	= 1;
	var widths    = new Array();
	/*
	to avoid problems in IE, focus the first input of the form
	*/
	$('#formElem').children(':first').find(':input:first').focus();	
	
	/* Reset height and width to match content 
	 */
	$(document).ready(function() {
    resizeHeight();
    resizeWidth();
  });

  $(window).on('resize', resizeWidth).on('resize', resizeHeight);
	
	/*
	show the navigation bar
	*/
	$('#navigation').show();


	// For Project form - if there are errors don't allow the user to submit
	$('.submit-form').bind('click',function(){
    validateSteps()
    if($('#formElem').data('errors')){
      Alert.newAlert('error', 'Please go back and correct any errors.');
      return false;
    } 
  });

	/*
	when clicking on a navigation link 
	the form slides to the corresponding fieldset
	*/
    $('#navigation a').bind('click',function(e){
		var $this	= $(this);
		var prev	= current;

		// check it forward sliding is enabled to the new level.
		// if not continue as required.
		if(app.allow_forward_sliding_till){
			if(parseInt($(e.target).closest('li').find('a').attr('data-stepIndex')) > app.allow_forward_sliding_till){
				e.preventDefault();
				return false;
			}else{
				// 
				app.allow_forward_sliding_till = $this.parent().index() + 1;
			}
		}

		$this.closest('ul').find('li').removeClass('selected');
        $this.parent().addClass('selected');
		/*
		we store the position of the link
		in the current variable	
		*/
		current = $this.parent().index() + 1;


		
		/*
		animate / slide to the next or to the corresponding
		fieldset. The order of the links in the navigation
		is the order of the fieldsets.
		Also, after sliding, we trigger the focus on the first 
		input element of the new fieldset
		If we clicked on the last link (confirmation), then we validate
		all the fieldsets, otherwise we validate the previous one
		before the form slided
		*/
        $('#steps').stop().animate({
            marginLeft: '-' + widths[current-1] + 'px'
        },500,function(){
				validateStep(prev);
			$('#formElem').children(':nth-child('+ parseInt(current) +')').find(':input:first').focus();	
		});
		    resizeHeight();
		    
        e.preventDefault();
    });
	
	/*
	validates errors on all the fieldsets
	records if the Form has errors in $('#formElem').data()
	*/
	function validateSteps(){
		var FormErrors = false;
		for(var i = 1; i < fieldsetCount; ++i){
			var error = validateStep(i);
			if(error == -1)
				FormErrors = true;
		}
		$('#formElem').data('errors',FormErrors);	
		console.log(FormErrors);
	}
	
	/*
	validates one fieldset
	and returns -1 if errors found, or 1 if not
	*/
	function validateStep(step){
		if(step == fieldsetCount) return;
		
		var error = 1;
		var hasError = false;
		
		/* We have to use step+1 here to avoid the CSRF token */
		$('#formElem').children(':nth-child('+ parseInt(step + 1) +')').find(':input:not(button)').each(function(){
			var $this 		= $(this);
			var valueLength = jQuery.trim($this.val()).length;
			
			if(valueLength == '' && $(this).hasClass('required')){ // Only looking for fields that have the class required
				hasError = true;
				$this.addClass('input-error');
			}
			else
			  $this.removeClass('input-error');
			
		});

		// errors identified by client side validation gem
		if($('#formElem').children(':nth-child('+ parseInt(step + 1) +')').find('.field_with_errors').length > 0){
			hasError = true
		}
		//console.log($('fieldset div .genre-select').val().length);

		if($('fieldset div #project_genre').length){
			if(Projects.validateGenre() || Projects.validateType() ){
				hasError = true;
				$this.addClass('input-error');
			}
			else
			  $this.removeClass('input-error');
	  }

		var $link = $('#navigation li:nth-child(' + parseInt(step) + ') a');

		$link.parent().find('.error,.checked').remove();
		
		var valclass = 'checked';
		if(hasError){
			error = -1;
			valclass = 'error';
		}
    $('#formElem').data('errors',hasError);
    
		$('<span class="'+valclass+'"></span>').insertAfter($link);

		// update the step li by adding it a class done.
		var current_li = $('#navigation li:nth-child(' + parseInt(step) + ')');
		current_li.addClass('done')
		
		return error;
	}
	
	function resizeWidth() {
	  /*
    sum and save the widths of each one of the fieldsets
    set the final sum as the total width of the steps element
    */
    var stepsWidth  = 0;
      
      $('#steps .step').each(function(i){
            var $step     = $(this);
            widths[i]     = stepsWidth;
            $step.width($step.parents('#wrapper').width());
            stepsWidth    += $step.width();
        });
      $('#steps').width(stepsWidth);
	}
	
	function resizeHeight() {
	 
    /* Create a data element for the current-index for fetching elsewhere */
    $('#steps').data('index', current);
	    var stepHeight = $('#steps .step:eq(' + (current - 1) + ')').height() + 50;
	    $('#steps').height(stepHeight);
	}
});