@initiateScrolling = (e) ->
  if $('#infinite-scrolling').length > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination .next_page').attr('href')
      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 160
        $('.pagination').html('<img src="loading.gif" alt="Loading..." title="Loading..." />')
        $.getScript more_posts_url
      return
    return

$(document).on 'turbolinks:load', initiateScrolling