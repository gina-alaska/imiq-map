# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class ExportStatus
  constructor: (@el, @status, @url) ->
    $(@el).on 'export.update', (e, data) =>
      @start(data.status)

    $(@el).on 'export.stop', () =>
      @stop()

    $(@el).on 'click', '[data-behavior="export.stop"]', () =>
      @stop()

    @start(@status)

  stop: () =>
    clearTimeout(@timer)

  start: (status) =>
    @stop()

    if status != 'Complete'
      @timer = setTimeout(@fetch, 2000)

  clear: () =>
    clearTimeout(@timer);

  fetch: () =>
    return unless $(@el).length > 0
    $.get(@url)


$(document).on 'click', '[data-toggle="checkboxes"]', (e) ->
  clicked_item = $(e.target)
  target = clicked_item.data('target')

  $(target).prop('checked', clicked_item.is(':checked'))

$(document).on 'export.start', (e, data) ->
  document.export_status = new ExportStatus(data.el, data.status, data.url)
