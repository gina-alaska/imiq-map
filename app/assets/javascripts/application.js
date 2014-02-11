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
//= require jquery_ujs
//= require turbolinks
//= require leaflet/leaflet
//= require gina-map-layers/adapters/leaflet
//= require leaflet.draw/dist/leaflet.draw
//= require markerclusters/dist/leaflet.markercluster
//= require wicket/wicket
//= require wicket/wicket-leaflet
//= require bootstrap/dist/js/bootstrap
//= require_tree .


$(document).on('ajax:before', function() {
  $('.spinner').removeClass('hidden');
});
$(document).on('ajax:complete', function() {
  $('.spinner').addClass('hidden');
});

var initialize_map = function() {
  console.log('test');
  if ($('#map')) {
    var map = new Map('map');
    $('#map').data('map', map);
    map.fromPagedAPI('#{ imiq_api.sites_uri }');    
  }
}

// $(document).on('ready', initialize_map);
$(document).on('page:change', initialize_map);