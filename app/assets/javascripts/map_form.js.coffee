class @MapForm
  constructor: (@map_container) ->
    # @map.on('moveend', @update_form_field)
    @setup_events()
    
    setTimeout () ->
      $('[data-toggle="tooltip"]').tooltip()
      $('[data-behavior="draw-aoi"]').tooltip('show')
    , 100
  
  setup_events: =>
    $(document).on 'click', '[data-behavior="reset-form"]', (e) =>
      e.preventDefault()
      $($(e.target).parents('form'))[0].reset()
      @reset_bounds()

    $(document).on 'change', '#search-form .bounds', (e) =>
      bounds = [
        [parseFloat($('#bounds_sw_lat').val()), parseFloat($('#bounds_sw_lng').val())],
        [parseFloat($('#bounds_ne_lat').val()), parseFloat($('#bounds_ne_lng').val())]
      ]
      @update_map_bounds(bounds,false)
  
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
          target.removeClass('btn-success')
          
      if @map_container.draw_tool.enabled()
        @map_container.draw_tool.disable()
      else
        @map_container.draw_tool.enable()
        target.addClass('btn-success')

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

  update_map_bounds: (points,autosubmit=true) =>
    try
      layer = L.rectangle(points, { color: '#f06eaa' })
      @map_container.drawBounds(layer)
      @update_bounds_fields(layer.getBounds(),autosubmit)
    catch
 #     @reset_bounds()

  update_form_field: =>
    @field.val(@map_container.map.getBounds().toBBoxString())

  submit: =>
    $('#bounds_ne_lng').parents('form').find('button[type="submit"]')[0].click()

  clear_bounds_fields: () ->
    $('#bounds_sw_lat').val('')
    $('#bounds_sw_lng').val('')
    $('#bounds_ne_lat').val('')
    $('#bounds_ne_lng').val('')

  update_bounds_fields: (bounds,autosubmit=true) ->
    $('#bounds_sw_lat').val(bounds.getSouthWest().lat)
    $('#bounds_sw_lng').val(bounds.getSouthWest().lng)
    $('#bounds_ne_lat').val(bounds.getNorthEast().lat)
    $('#bounds_ne_lng').val(bounds.getNorthEast().lng)
    @submit() if autosubmit

    
