class @MapForm
  constructor: (@map_container) ->
    # @map.on('moveend', @update_form_field)
    @setup_events()

    setTimeout () ->
      $('[data-toggle="tooltip"]').tooltip()
      $('[data-action="show-tooltip"]').tooltip('show')
    , 100

  setup_events: =>
    $(document).on 'map:load', () =>
      @draw_map_bounds()
      @submit()

    $(document).on 'aoi::drawn', (e, layer) ->
      $('#bounds_field').val(layer.getBounds().toBBoxString())

    $(document).on 'aoi::removed', (e) ->
      $('#bounds_field').val('')

    $(document).on 'click', '[data-behavior="reset-form"]', (e) =>
      e.preventDefault()
      form = $($(e.target).parents('form'))[0]

      # $($(e.target).parents('form'))[0].reset()
      for el in form.elements
        field_type = el.type.toLowerCase();
        switch field_type
          when "text", "password", "textarea", "hidden"
            el.value = ""
          when "radio", "checkbox"
            if el.checked
              el.checked = false;
          when "select-one", "select-multi"
            el.selectedIndex = -1;
      @reset_bounds()
      @submit()

    $(document).on 'change', '#search-form .bounds', (e) =>
      @draw_map_bounds()

    $(document).on 'click', '[data-behavior="clear-aoi"]', (e) =>
      e.preventDefault()
      @reset_bounds()
      @submit()

    $(document).on 'click', '[data-behavior="draw-aoi"]', (e) =>
      e.preventDefault()

      target = $(e.currentTarget)

      unless @map_container.draw_tool?
        @map_container.draw_tool = new L.Draw.Rectangle(@map_container.map)
        @map_container.draw_tool.on 'disabled', =>
          $('[data-behavior="draw-aoi"]').removeClass('btn-success')

      if @map_container.draw_tool.enabled()
        @map_container.draw_tool.disable()
      else
        @map_container.draw_tool.enable()
        $('[data-behavior="draw-aoi"]').addClass('btn-success')

    $(document).on 'click', '[data-behavior="export-sites"]', (e) =>
      e.preventDefault()
      $('#commit_value').val('export-sites')
      @submit()
      $('#commit_value').val('submit')

    $(document).on 'click', '[data-behavior="export"]', (e) =>
      e.preventDefault()
      $('#commit_value').val('export')
      @submit()
      $('#commit_value').val('submit')

  reset_bounds: =>
    @clear_bounds_fields()
    @map_container.clearBounds()

  draw_map_bounds: (autosubmit = false) =>
    bounds = [
      [parseFloat($('#bounds_sw_lat').val()), parseFloat($('#bounds_sw_lng').val())],
      [parseFloat($('#bounds_ne_lat').val()), parseFloat($('#bounds_ne_lng').val())]
    ]
    @update_map_bounds(bounds,autosubmit)

  update_map_bounds: (points,autosubmit=true) =>
    try
      layer = L.rectangle(points, { color: '#f06eaa' })
      @map_container.drawBounds(layer)
      @update_bounds_fields(layer.getBounds(),autosubmit)
    catch e

  update_form_field: =>
    @field.val(@map_container.map.getBounds().toBBoxString())

  submit: =>
    $('#search-form button[type="submit"]')[0].click()

  clear_bounds_fields: (autosubmit = true) ->
    $('#bounds_sw_lat').val('')
    $('#bounds_sw_lng').val('')
    $('#bounds_ne_lat').val('')
    $('#bounds_ne_lng').val('')
    @submit() if autosubmit

  update_bounds_fields: (bounds,autosubmit=true) ->
    $('#bounds_sw_lat').val(bounds.getSouthWest().lat)
    $('#bounds_sw_lng').val(bounds.getSouthWest().lng)
    $('#bounds_ne_lat').val(bounds.getNorthEast().lat)
    $('#bounds_ne_lng').val(bounds.getNorthEast().lng)
    @submit() if autosubmit
