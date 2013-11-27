# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class @Map
  constructor: (@selector, when_ready_func = null) ->
    L.Icon.Default.imagePath = '/images';
    @map = L.map(@selector).setView([65, -155], 5)
    
    L.tileLayer('http://tiles.gina.alaska.edu/tilesrv/bdl/tile/{x}/{y}/{z}', {
      maxZoom: 15
    }).addTo(@map);
    
    @map.whenReady(when_ready_func, @) if when_ready_func? 
  
  fromPagedAPI: (url) =>
    @progress ||= new Progress('loading sites...')
    
    request = @fromAPI(url)
    request.done (response, text, xhr) => 
      links = $.parseJSON(xhr.getResponseHeader('Links'))
      
      if links.next_page?
        @progress.update(parseInt(links.offset / links.total * 100))
        @fromPagedAPI(links.next_page) 
      else
        @progress.done()
        delete @progress
    request.fail (response) =>
      if @progress?
        @progress.done()
        delete @progress
      
  fromAPI: (url) =>
    $.getJSON url, (response) =>
      @fromGeoJSON(response)
  
  fromGeoJSON: (geojson) =>
    unless @markers?
      @markers = new L.MarkerClusterGroup()
      @map.addLayer(@markers)
      @markers.on('click', @markerClick)
          
    @markers.addLayer(
      L.geoJson(geojson, {
        onEachFeature: (feature, layer) =>
          layer.bindPopup(@description(feature));
      })
    )
    
    # this is needed to handle issue with zooming to soon after initialization
    # setTimeout(=> 
    #   @map.fitBounds(@markers.getBounds())
    # , 100)
    
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
      
  description: (feature) ->
    output = "<fieldset class='site-marker-popup'><legend>#{feature.properties.sitename}</legend>"
    output +=  "<label>Location: </label> (#{feature.geometry.coordinates[1]}, #{feature.geometry.coordinates[0]})<br/>
                <label>Elevation:</label> #{feature.geometry.coordinates[2]} (M)<br/>"
    output +=  "<label>Comments: </label> #{feature.properties.comments}<br/>" if feature.properties.comments?
    output += "</fieldset>"
    
    output
