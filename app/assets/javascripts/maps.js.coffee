# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
L.mapbox.accessToken = 'pk.eyJ1IjoiZ2luYS1hbGFza2EiLCJhIjoiN0lJVnk5QSJ9.CsQYpUUXtdCpnUdwurAYcQ'
class @Map
  constructor: (@selector, when_ready_func = null) ->
    @form = new MapForm(@)

    L.Icon.Default.imagePath = '/images';
    @map = L.mapbox.map(@selector, {
      "attribution": "<a href='https://www.mapbox.com/about/maps/' target='_blank'>&copy; Mapbox &copy; OpenStreetMap</a> <a class='mapbox-improve-map' href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a>",
      "autoscale": true,
      "bounds": [-180, -85, 180, 85],
      "description": "Lighter colors to work better on presentation",
      "maxzoom": 19,
      "minzoom": 0,
      "name": "IMIQ Map",
      "scheme": "xyz",
      "tilejson": "2.0.0",
      "drawControlTooltips": true,
      "tiles": ["http://a.tiles.mapbox.com/v3/gina-alaska.heb1gpfg/{z}/{x}/{y}.png", "http://b.tiles.mapbox.com/v3/gina-alaska.heb1gpfg/{z}/{x}/{y}.png", "http://c.tiles.mapbox.com/v3/gina-alaska.heb1gpfg/{z}/{x}/{y}.png", "http://d.tiles.mapbox.com/v3/gina-alaska.heb1gpfg/{z}/{x}/{y}.png"],
    })
    @initializeDrawControls()

    @map.on 'load', () =>
      $(document).trigger('map:load', [@])

    @map.options.drawControlTooltips = true
    @defaultZoom()

    baseLayers = {
      'Terrain': L.mapbox.tileLayer('gina-alaska.heb1gpfg')
      'GINA BestDataLayer': L.tileLayer('http://tiles.gina.alaska.edu/tilesrv/bdl/tile/{x}/{y}/{z}?GOGC=C181D5D73000', {
        maxZoom: 15
      })
    }
    #
    # for slug in ['TILE.EPSG:3857.BDL', 'TILE.EPSG:3857.TOPO', 'TILE.EPSG:3857.SHADED_RELIEF', 'TILE.EPSG:3857.LANDSAT_PAN']
    #   l = Gina.Layers.get(slug, true)
    #   baseLayers[l.name] = l.instance if l?
    #
    #
    @map.addLayer(baseLayers['Terrain'])

    @layers_control = L.control.layers(baseLayers, [], {
      autoZIndex: true
    }).addTo(@map)

    L.control.coordinates({
      position:"bottomleft",
      useLatLngOrder: true
    }).addTo(@map)

  defaultZoom: =>
    @map.setView([64.20637724320852, -152.841796875], 5)

  clearMarkers: =>
    if @request?
      @request.abort();
    if @markers?
      @markers.clearLayers();

  filterByBounds: (bounds) =>
    @markers.clearLayers()

  startSearch: =>
    @progress = new Progress("##{@selector}", 'loading sites...')

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

  initializeDrawControls: =>
    # Initialise the FeatureGroup to store editable layers
    @drawnItems = new L.FeatureGroup()
    @map.addLayer(@drawnItems)

    # Initialise the draw control and pass it the FeatureGroup of editable layers
    @drawControl = new L.Control.Draw({
      draw: {
        polyline: false,
        polygon: false,
        circle: false,
        marker: false,
        rectangle: false
      },
      edit: false
      remove: false
    })
    @map.addControl(@drawControl)

    @map.on('draw:created', @handleDrawCreated)
    @map.on('draw:edited', @handleDrawEdited)
    @map.on('draw:deleted', @handleDrawDeleted)

  handleDrawDeleted: (e) =>
    clearBounds()

  handleDrawEdited: (e) =>
    e.layers.eachLayer (l) =>
      @filterByLayer(l)

  handleDrawCreated: (e) =>
    layer = e.layer
    @filterByLayer(layer)

  drawBounds: (layer) =>
    @drawnItems.clearLayers()
    @drawnItems.addLayer(layer)
    @zoomToBounds(layer)

  clearBounds: () =>
    @drawnItems.clearLayers()
    @defaultZoom()
    $(document).trigger('aoi::removed')

  zoomToBounds: (layer) =>
    @map.fitBounds(layer)

  filterByLayer: (layer) =>
    bounds = layer.getBounds()
    @drawBounds(layer)

    $(document).trigger('aoi::drawn', [layer])

    @form.update_bounds_fields(bounds)

  finishRequest: =>
    @progress.done()

  fromAPI: (url) =>
    $.getJSON url, @fromGeoJSON


  geojsonMarkerOptions: {
      radius: 8,
      fillColor: "#d13636",
      color: "#000",
      weight: 1,
      opacity: 1,
      fillOpacity: 0.8
  }

  clusterConfig: () =>
    if IMIQ? and IMIQ.IE
      { disableClusteringAtZoom: 8 }
    else
      { maxClusterRadius: 50, disableClusteringAtZoom: 5 }

  fromGeoJSON: (geojson) =>
    unless @markers?
      @markers = new L.MarkerClusterGroup(@clusterConfig())
      @map.addLayer(@markers)

    @markers.addLayer(
      L.geoJson(geojson, {
        pointToLayer: (feature, latlng) =>
          L.circleMarker(latlng, @geojsonMarkerOptions);
        onEachFeature: (feature, layer) =>
          layer.once 'click', (e) ->
            $.get("/sites/#{this.feature.properties.id}").done (content) =>
              this.bindPopup(content, { maxWidth: 500, minWidth: 400 })
              this.openPopup(e.latlng)
            # this.bindPopup(this.feature.properties.url)
            # this.openPopup(e.latlng)
          # layer.bindPopup(@description(feature), { maxWidth: 500 });
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

  generate_graph_tabs: (tab_content) ->
    output = ''
    if tab_content.length > 2
      output = tab_content[0..1].join(' ')
      output += '
          <li class="dropdown navbar-right"><a href="#" class="dropdown-toggle" data-toggle="dropdown">More <b class="caret"></b></a>
            <ul class="dropdown-menu">'

      output += tab_content[2..tab_content.length].join(' ')

      output += '
            </ul>
          </li>'
    else
      output = tab_content.join(' ')

    output

  description: (feature) ->
    derived_variables = []
    variable_output = ""
    graph_tab_panes = ""
    graph_tabs = []

    for index,item of feature.properties.derived_variables
      for variable in item
        if index != 'source'
          derived_variables.push(variable[0]) unless derived_variables.indexOf(variable[0]) >= 0
        if index == 'daily'
          graph_tabs.push("<li><a href=\"#graph_#{variable[1]}\" data-toggle=\"tab\" data-behavior=\"load-content\" data-url=\"/graphs/#{feature.properties.siteid}?variable=#{variable[1]}\">#{variable[0]}</a></li>")
          graph_tab_panes += "
          <div class=\"tab-pane\" id=\"graph_#{variable[1]}\">
          </div>
          "

    variable_output = derived_variables.sort().join(', ')

    output = """
      <div class='site-marker-popup'>
        <h1>#{feature.properties.sitename}</h1>
        <ul class="nav nav-tabs">
          <li class="active"><a href="#site" data-toggle="tab">Site</a></li>
          #{@generate_graph_tabs(graph_tabs)}
        </ul>
        <div class="tab-content">
          <div class="tab-pane active" id="site">
            <dl class="dl-horizontal">
              <dt>Site ID (Site Code): </dt><dd> #{feature.properties.siteid} (#{feature.properties.sitecode})</dd>
              <dt>Lat/Lon/Elev: </dt><dd> (#{parseFloat(feature.geometry.coordinates[1]).toFixed(3)}, #{parseFloat(feature.geometry.coordinates[0]).toFixed(3)}, #{parseFloat(feature.geometry.coordinates[2]).toFixed(2)} M) </dd>
              <dt>Networks: </dt><dd> #{feature.properties.networks} </dd>
              <dt>Organizations: </dt><dd> #{feature.properties.source.organization} </dd>
              <dt>Contact Name: </dt><dd> #{feature.properties.source.contactname} </dd>
              <dt>Contact Link: </dt><dd> <a href=#{feature.properties.source.sourcelink} target="_blank">#{feature.properties.source.sourcelink}</a></dd>
              <dt>Start Date (UTC): </dt><dd> #{feature.properties.begin_date} </dd>
              <dt>End Date (UTC): </dt><dd> #{feature.properties.end_date}</dd>
              <dt><abbr title="Exportable Geophysical Parameters">Summary Products</abbr>: </dt>
              <dd>#{variable_output} &nbsp;</dd>
              <dt><abbr title="Available-by-Request Source Parameters">Source Data</abbr>: </dt>
              <dd>
              #{feature.properties.variables.join(", ")}
              </dd>
            </dl>
          </div>
          #{graph_tab_panes}
        </div>
      </div>
    <a href="/exports/new?siteid=#{feature.properties.siteid}" data-remote="true" class="btn btn-block btn-primary" >Export</a>
    """

    output
