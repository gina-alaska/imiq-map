class @MapForm
  constructor: (@map_container) ->
    # @map.on('moveend', @update_form_field)
    $(document).on 'change', '#search-form .bounds', (e) =>
      bounds = [
        [parseFloat($('#bounds_sw_lat').val()), parseFloat($('#bounds_sw_lng').val())],
        [parseFloat($('#bounds_ne_lat').val()), parseFloat($('#bounds_ne_lng').val())]
      ]
      @update_map_bounds(bounds)
      
  update_map_bounds: (points) =>
    try
      @map_container.drawBounds(L.rectangle(points, { color: '#f06eaa' }))
    catch
    
  update_form_field: =>
    @field.val(@map_container.map.getBounds().toBBoxString())
    
  update_bounds_fields: (bounds) ->
    $('#bounds_sw_lat').val(bounds.getSouthWest().lat)
    $('#bounds_sw_lng').val(bounds.getSouthWest().lng)
    $('#bounds_ne_lat').val(bounds.getNorthEast().lat)
    $('#bounds_ne_lng').val(bounds.getNorthEast().lng)