// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks

//= require mapbox.js/dist/mapbox.js
//= require gina-map-layers/adapters/leaflet
//= require leaflet.draw/dist/leaflet.draw
//= require leaflet.markercluster/dist/leaflet.markercluster
//= require Leaflet.Coordinates/dist/Leaflet.Coordinates-0.1.3.min.js
//= require wicket/wicket
//= require wicket/wicket-leaflet
//= require bootstrap/dist/js/bootstrap
//= require bootstrap3-datepicker/js/bootstrap-datepicker
//= require Highcharts-4.0.1/js/highcharts
//= require chartkick
//= require jQuery-ajaxTransport-XDomainRequest/jQuery.XDomainRequest
//= stub ie
//= require_tree .

var initialize_map = function() {
  el = $('#map');
  if (el[0]) {
    var map = new Map('map');
    var form = new MapForm(map)
    $('#map').data('map', map);
    $('document').trigger('map:load', [map]);

    // var bounds = map.map.getBounds();
    // map.form.update_bounds_fields(bounds);
    $('#search-form').submit();
  }
}

var load_map_results = function(url) {
  if (!$.support.cors) {
    url = url + '&limit=100000';
    showSpinner();
  }
  
  var map = $('#map').data('map');
  map.startSearch();
  map.clearMarkers();
  map.fromPagedAPI(url);
}

showSpinner = function() {
  $('.spinner').removeClass('hidden');
};

hideSpinner = function() {
  $('.spinner').addClass('hidden');
}

// $(document).on('ready', initialize_map);
$(document).ready(function() {
  initialize_map();
  
  $(document).on('ajax:before', function() {
    showSpinner();
  });
  $(document).on('ajax:complete', function() {
    hideSpinner();
  });
  $(document).on('ajax:success', function() {
    hideSpinner();
  });
  $(document).on('ajax:error', function() {
    hideSpinner();
  });

  $(document).on('page:fetch', function() {
    showSpinner();
  });
  $(document).on('page:load', function() {
    hideSpinner();
  });  
})
