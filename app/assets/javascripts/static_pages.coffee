# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@submitForm = (e) ->
  $.get $('#search-form').attr('action'), $('#search-form').serialize(), null, 'script'
  return

@bindSearchInputFunctionality = (e) ->
  if e.which != 16 && e.which != 17 && e.which != 18 && e.which != 32
    submitForm()
  false

$(document).on 'keyup', '#search-form input[type="text"]', bindSearchInputFunctionality
$(document).on 'change', '#search-form input[type="checkbox"]', submitForm
$(document).on 'change', '#search-form input[type="radio"]', submitForm