class @MapForm
  constructor: (@map_container) ->
    # @map.on('moveend', @update_form_field)
    $(document).on 'click', '[data-behavior="reset-form"]', (e) =>
      e.preventDefault()
      $($(e.target).parents('form'))[0].reset()
      @map_container.clearBounds()

    $(document).on 'change', '#search-form .bounds', (e) =>
      bounds = [
        [parseFloat($('#bounds_sw_lat').val()), parseFloat($('#bounds_sw_lng').val())],
        [parseFloat($('#bounds_ne_lat').val()), parseFloat($('#bounds_ne_lng').val())]
      ]
      @update_map_bounds(bounds)

  update_map_bounds: (points) =>
    try
      layer = L.rectangle(points, { color: '#f06eaa' })
      @map_container.drawBounds(layer)
      @update_bounds_fields(layer.getBounds())
    catch
      @map_container.clearBounds()

  update_form_field: =>
    @field.val(@map_container.map.getBounds().toBBoxString())

  clear_bounds_fields: () ->
    $('#bounds_sw_lat').val('')
    $('#bounds_sw_lng').val('')
    $('#bounds_ne_lat').val('')
    $('#bounds_ne_lng').val('')

  update_bounds_fields: (bounds) ->
    $('#bounds_sw_lat').val(bounds.getSouthWest().lat)
    $('#bounds_sw_lng').val(bounds.getSouthWest().lng)
    $('#bounds_ne_lat').val(bounds.getNorthEast().lat)
    $('#bounds_ne_lng').val(bounds.getNorthEast().lng)
