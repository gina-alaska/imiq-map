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
    @progress = new Progress("##{@selector}", 'loading sites...')
          
  
  clearMarkers: =>
    if @request?
      @request.abort();
      
    @markers.clearLayers();
  
  fromPagedAPI: (url) =>
    @request = @fromAPI(url)
    @request.done (response, text, xhr) => 
      links = {
        next_page: xhr.getResponseHeader('X-Next-Link'),
        offset: parseInt(xhr.getResponseHeader('X-Page')),
        total: parseInt(xhr.getResponseHeader('X-Total-Pages'))
      }
      # links = {}
      
      if links.next_page? and links.next_page != ''
        @progress.update(parseInt(links.offset / links.total * 100))
        @fromPagedAPI(links.next_page) 
      else
        @finishRequest()
        
    @request.fail @finishRequest
      
  finishRequest: =>
    @progress.done()      
      
  fromAPI: (url) =>
    $.getJSON url, @fromGeoJSON
  
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
    output = """
      <fieldset class='site-marker-popup'><legend>#{feature.properties.sitename}</legend>
        <label>Site ID: </label> #{feature.properties.siteid}<br/>
        <label>Lat/Lon/Elev: </label> (#{feature.geometry.coordinates[1].toFixed(2)}, #{feature.geometry.coordinates[0].toFixed(2)}, #{feature.geometry.coordinates[2]} M) <br/>
        <label>Organization: </label> #{feature.properties.source.organization} <br/>
        <label>Contact Name: </label> #{feature.properties.source.contactname} <br/>
        <label>Contact Info: </label> <a href=#{feature.properties.source.sourcelink} target="_blank">#{feature.properties.source.sourcelink}</a><br/>
        <label>Start Date (UTC): </label> #{feature.properties.begindatetimeutc} <br/>
        <label>End Date (UTC): </label> #{feature.properties.enddatetimeutc} <br/>
        <label>Variables: </label> <br/>
        #{feature.properties.variables.join("<br/>")}<br/>
        <a href="/sites/#{feature.properties.siteid}" data-remote="true" class="btn btn-primary">Export</a>
      </fieldset>
    """
    
    output
