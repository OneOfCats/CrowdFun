# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@bindSearchFunctionality = (e) ->
  if e.which != 16 && e.which != 17 && e.which != 18 && e.which != 32
    $("#projects-block").html ""
    $.get $('#search-form').attr('action'), $('#search-form').serialize(), null, 'script'
  false

$(document).on 'keyup', '#search-form input[type="text"]', bindSearchFunctionality