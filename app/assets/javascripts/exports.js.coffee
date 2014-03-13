# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'click', '[data-toggle="checkboxes"]', (e) ->
  clicked_item = $(e.target)
  target = clicked_item.data('target')

  $(target).prop('checked', clicked_item.is(':checked'))
