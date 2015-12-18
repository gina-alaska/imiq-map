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

//= require mapbox.js
//= require gina-map-layers/adapters/leaflet
//= require leaflet-draw
//= require leaflet.markercluster
//= require Leaflet.Coordinates
//= require wicket/wicket
//= require wicket/wicket-leaflet
//= require bootstrap
//= require moment/min/moment.min
//= require eonasdan-bootstrap-datetimepicker
//= require highcharts
//= require chartkick
//= require jQuery-ajaxTransport-XDomainRequest/jQuery.XDomainRequest
//= stub ie
//= require_tree .

var initialize_map = function() {
  el = $('#map');
  if (el[0]) {
    var map = new Map('map');
    $('#map').data('map', map);
    $('document').trigger('map:load', [map]);
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
