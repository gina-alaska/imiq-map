# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class @Map
  constructor: (@selector, when_ready_func = null) ->
    @ready = false
    @map = L.map(@selector).setView([64.8658580026598, -147.83855438232422], 3)
    
    L.tileLayer('http://tiles.gina.alaska.edu/tilesrv/bdl/tile/{x}/{y}/{z}', {
      maxZoom: 18
    }).addTo(@map);
    @map.on 'zoomend', =>
      console.log @map.getZoom()
    @map.whenReady(when_ready_func, @) if when_ready_func? 
    
  fromGeoJSON: (geojson) =>
    @features = L.geoJson(geojson)
    @features.addTo(@map);
    
    # this is needed to handle issue with zooming to soon after initialization
    setTimeout(=> 
      @map.fitBounds(@features.getBounds())
    , 100)
    
  fromWKT: (wkt, fit = true) =>
    reader = new Wkt.Wkt();
    reader.read(wkt)
    object = reader.toObject()
    object.addTo(@map)
    if fit
      # this is needed to handle issue with zooming to soon after initialization
      setTimeout =>
        @map.fitBounds(object.getBounds(), { animate: true })
      , 100
      
      
