@slideTarget = (e) ->
  $($(@).data('target')).slideToggle 100
  false

@hamburgerToggle = (e) ->
  if $(this).hasClass('is-active')
    $(this).removeClass('is-active')
    $("#mobile-menu").slideUp()
  else
    $(this).addClass('is-active')
    $("#mobile-menu").slideDown()
  return

@hamburgerClose = (e) ->
  if $(e.target).closest('#mobile-menu').length > 0 || $(e.target).closest('.c-hamburger').length > 0
    return
  $("#mobile-menu").slideUp()
  $(".c-hamburger").removeClass('is-active')
  return

$(document).on 'click', '[data-function="slide"]', slideTarget
$(document).on 'click', '.c-hamburger', hamburgerToggle
$(document).on 'click', hamburgerClose