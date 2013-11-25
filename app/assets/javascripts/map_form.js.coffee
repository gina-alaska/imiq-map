class @MapForm
  constructor: (@map, @field) ->
    @map.on('moveend', @update_form_field)
    
  update_form_field: =>
    @field.val(@map.getBounds().toBBoxString())