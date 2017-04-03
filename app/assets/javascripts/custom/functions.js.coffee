@slideTarget = (e) ->
  $($(@).data('target')).slideToggle 100
  false

$(document).on 'click', '[data-function="slide"]', slideTarget