# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'shown.bs.tab', '[data-behavior="load-content"]', (e) ->
  console.log 'test'
  item = $(this)
  pane = $(item.attr('href'))
  url = item.data('url')
  if pane.data('loaded') != true
    pane.load(url)
    pane.data('loaded', true)