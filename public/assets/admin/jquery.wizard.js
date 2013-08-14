/*
 * jQuery wizard plug-in 3.0.5
 *
 *
 * Copyright (c) 2011 Jan Sundman (jan.sundman[at]aland.net)
 *
 * http://www.thecodemine.org
 *
 * Licensed under the MIT licens:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 */
!function(t){t.widget("ui.formwizard",{_init:function(){var e=this,i=this.options.formOptions.success,n=this.options.formOptions.complete,s=this.options.formOptions.beforeSend,o=this.options.formOptions.beforeSubmit,r=this.options.formOptions.beforeSerialize;return this.options.formOptions=t.extend(this.options.formOptions,{success:function(t,n,s){i&&i(t,n,s),(e.options.formOptions&&e.options.formOptions.resetForm||!e.options.formOptions)&&e._reset()},complete:function(t,i){n&&n(t,i),e._enableNavigation()},beforeSubmit:function(t,i,n){if(o){var s=o(t,i,n);return s||e._enableNavigation(),s}},beforeSend:function(t){if(s){var i=s(t);return i||e._enableNavigation(),i}},beforeSerialize:function(t,i){if(r){var n=r(t,i);return n||e._enableNavigation(),n}}}),this.steps=this.element.find(".step").hide(),this.firstStep=this.steps.eq(0).attr("id"),this.activatedSteps=new Array,this.isLastStep=!1,this.previousStep=void 0,this.currentStep=this.steps.eq(0).attr("id"),this.nextButton=this.element.find(this.options.next).click(function(){return e._next()}),this.nextButtonInitinalValue=this.nextButton.val(),this.nextButton.val(this.options.textNext),this.backButton=this.element.find(this.options.back).click(function(){return e._back(),!1}),this.backButtonInitinalValue=this.backButton.val(),this.backButton.val(this.options.textBack),this.options.validationEnabled&&void 0==jQuery().validate?(this.options.validationEnabled=!1,void 0!==window.console&&console.log("%s","validationEnabled option set, but the validation plugin is not included")):this.options.validationEnabled&&this.element.validate(this.options.validationOptions),this.options.formPluginEnabled&&void 0==jQuery().ajaxSubmit&&(this.options.formPluginEnabled=!1,void 0!==window.console&&console.log("%s","formPluginEnabled option set but the form plugin is not included")),1==this.options.disableInputFields&&t(this.steps).find(":input:not('.wizard-ignore')").attr("disabled","disabled"),this.options.historyEnabled&&t(window).bind("hashchange",void 0,function(i){var n=i.getState("_"+t(e.element).attr("id"))||e.firstStep;if(n!==e.currentStep){if(e.options.validationEnabled&&n===e._navigate(e.currentStep)&&!e.element.valid())return e._updateHistory(e.currentStep),e.element.validate().focusInvalid(),!1;n!==e.currentStep&&e._show(n)}}),this.element.addClass("ui-formwizard"),this.element.find(":input").addClass("ui-wizard-content"),this.steps.addClass("ui-formwizard-content"),this.backButton.addClass("ui-formwizard-button ui-wizard-content"),this.nextButton.addClass("ui-formwizard-button ui-wizard-content"),this.options.disableUIStyles||(this.element.addClass("ui-helper-reset ui-widget ui-widget-content ui-helper-reset ui-corner-all"),this.element.find(":input").addClass("ui-helper-reset ui-state-default"),this.steps.addClass("ui-helper-reset ui-corner-all"),this.backButton.addClass("ui-helper-reset ui-state-default"),this.nextButton.addClass("ui-helper-reset ui-state-default")),this._show(void 0),t(this)},_next:function(){if(this.options.validationEnabled&&!this.element.valid())return this.element.validate().focusInvalid(),!1;if(void 0!=this.options.remoteAjax){var e=this.options.remoteAjax[this.currentStep],i=this;if(void 0!==e){var n=e.success,s=e.beforeSend,o=e.complete;return e=t.extend({},e,{success:function(t,e){(void 0!==n&&n(t,e)||void 0==n)&&i._continueToNextStep()},beforeSend:function(e){i._disableNavigation(),void 0!==s&&s(e),t(i.element).trigger("before_remote_ajax",{currentStep:i.currentStep})},complete:function(e,n){void 0!==o&&o(e,n),t(i.element).trigger("after_remote_ajax",{currentStep:i.currentStep}),i._enableNavigation()}}),this.element.ajaxSubmit(e),!1}}return this._continueToNextStep()},_back:function(){return this.activatedSteps.length>0&&(this.options.historyEnabled?this._updateHistory(this.activatedSteps[this.activatedSteps.length-2]):this._show(this.activatedSteps[this.activatedSteps.length-2],!0)),!1},_continueToNextStep:function(){if(this.isLastStep){for(var t=0;t<this.activatedSteps.length;t++)this.steps.filter("#"+this.activatedSteps[t]).find(":input").not(".wizard-ignore").removeAttr("disabled");return this.options.formPluginEnabled?(this._disableNavigation(),this.element.ajaxSubmit(this.options.formOptions),!1):!0}var e=this._navigate(this.currentStep);return e==this.currentStep?!1:(this.options.historyEnabled?this._updateHistory(e):this._show(e,!0),!1)},_updateHistory:function(e){var i={};i["_"+t(this.element).attr("id")]=e,t.bbq.pushState(i)},_disableNavigation:function(){this.nextButton.attr("disabled","disabled"),this.backButton.attr("disabled","disabled"),this.options.disableUIStyles||(this.nextButton.removeClass("ui-state-active").addClass("ui-state-disabled"),this.backButton.removeClass("ui-state-active").addClass("ui-state-disabled"))},_enableNavigation:function(){this.isLastStep?this.nextButton.val(this.options.textSubmit):this.nextButton.val(this.options.textNext),t.trim(this.currentStep)!==this.steps.eq(0).attr("id")&&(this.backButton.removeAttr("disabled"),this.options.disableUIStyles||this.backButton.removeClass("ui-state-disabled").addClass("ui-state-active")),this.nextButton.removeAttr("disabled"),this.options.disableUIStyles||this.nextButton.removeClass("ui-state-disabled").addClass("ui-state-active")},_animate:function(t,e,i){this._disableNavigation();var n=this.steps.filter("#"+t),s=this.steps.filter("#"+e);n.find(":input").not(".wizard-ignore").attr("disabled","disabled"),s.find(":input").not(".wizard-ignore").removeAttr("disabled");var o=this;n.animate(o.options.outAnimation,o.options.outDuration,o.options.easing,function(){s.animate(o.options.inAnimation,o.options.inDuration,o.options.easing,function(){o.options.focusFirstInput&&s.find(":input:first").focus(),o._enableNavigation(),i.apply(o)})})},_checkIflastStep:function(e){this.isLastStep=!1,(t("#"+e).hasClass(this.options.submitStepClass)||this.steps.filter(":last").attr("id")==e)&&(this.isLastStep=!0)},_getLink:function(e){var i=void 0,n=this.steps.filter("#"+e).find(this.options.linkClass);return void 0!=n&&(i=n.filter(":radio,:checkbox").size()>0?n.filter(this.options.linkClass+":checked").val():t(n).val()),i},_navigate:function(t){var e=this._getLink(t);if(void 0!=e)return""!=e&&null!=e&&void 0!=e&&void 0!=this.steps.filter("#"+e).attr("id")?e:this.currentStep;if(void 0==e&&!this.isLastStep){var i=this.steps.filter("#"+t).next().attr("id");return i}},_show:function(e){var i=!1,n=void 0!==e;if(void 0==e||""==e?(this.activatedSteps.pop(),e=this.firstStep,this.activatedSteps.push(e)):t.inArray(e,this.activatedSteps)>-1?(i=!0,this.activatedSteps.pop()):this.activatedSteps.push(e),this.currentStep!==e||e===this.firstStep){this.previousStep=this.currentStep,this._checkIflastStep(e),this.currentStep=e;var s=function(){n&&t(this.element).trigger("step_shown",t.extend({isBackNavigation:i},this._state()))};this._animate(this.previousStep,e,s)}},_reset:function(){this.element.resetForm(),t("label,:input,textarea",this).removeClass("error");for(var e=0;e<this.activatedSteps.length;e++)this.steps.filter("#"+this.activatedSteps[e]).hide().find(":input").attr("disabled","disabled");this.activatedSteps=new Array,this.previousStep=void 0,this.isLastStep=!1,this.options.historyEnabled?this._updateHistory(this.firstStep):this._show(this.firstStep)},_state:function(t){var e={settings:this.options,activatedSteps:this.activatedSteps,isLastStep:this.isLastStep,isFirstStep:this.currentStep===this.firstStep,previousStep:this.previousStep,currentStep:this.currentStep,backButton:this.backButton,nextButton:this.nextButton,steps:this.steps,firstStep:this.firstStep};return void 0!==t?e[t]:e},show:function(t){this.options.historyEnabled?this._updateHistory(t):this._show(t)},state:function(t){return this._state(t)},reset:function(){this._reset()},next:function(){this._next()},back:function(){this._back()},destroy:function(){this.element.find("*").removeAttr("disabled").show(),this.nextButton.unbind("click").val(this.nextButtonInitinalValue).removeClass("ui-state-disabled").addClass("ui-state-active"),this.backButton.unbind("click").val(this.backButtonInitinalValue).removeClass("ui-state-disabled").addClass("ui-state-active"),this.backButtonInitinalValue=void 0,this.nextButtonInitinalValue=void 0,this.activatedSteps=void 0,this.previousStep=void 0,this.currentStep=void 0,this.isLastStep=void 0,this.options=void 0,this.nextButton=void 0,this.backButton=void 0,this.formwizard=void 0,this.element=void 0,this.steps=void 0,this.firstStep=void 0},update_steps:function(){this.steps=this.element.find(".step").addClass("ui-formwizard-content"),this.steps.not("#"+this.currentStep).hide().find(":input").addClass("ui-wizard-content").attr("disabled","disabled"),this._checkIflastStep(this.currentStep),this._enableNavigation(),this.options.disableUIStyles||(this.steps.addClass("ui-helper-reset ui-corner-all"),this.steps.find(":input").addClass("ui-helper-reset ui-state-default"))},options:{historyEnabled:!1,validationEnabled:!1,validationOptions:void 0,formPluginEnabled:!1,linkClass:".link",submitStepClass:"submit_step",back:":reset",next:":submit",textSubmit:"Submit",textNext:"Next",textBack:"Back",remoteAjax:void 0,inAnimation:{opacity:"show"},outAnimation:{opacity:"hide"},inDuration:400,outDuration:400,easing:"swing",focusFirstInput:!1,disableInputFields:!0,formOptions:{reset:!0,success:function(){void 0!==window.console&&console.log("%s","form submit successful")},disableUIStyles:!1}}})}(jQuery);