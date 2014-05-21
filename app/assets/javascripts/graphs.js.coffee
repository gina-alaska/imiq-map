# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


class @LineGraph
  constructor: (@el, opts) ->
    @options = {
      chart: {
        type: 'line',
        zoomType: 'x'
      },
      xAxis: {
        type: 'datetime',
        labels: {
          format: '{value:%Y-%m-%d}',
          rotation: 45,
          align: 'left'
        }
      },
      series: []
    }
    
    @extendOptions(opts)
    
  extendOptions: (opts) =>
    if opts?
      $.extend(true, @options, opts)
  
  buildChart: () =>
    @chart = $(@el).highcharts(@options)
    
  loadJSON: (data) =>
    @extendOptions(data)
    # @options.series = data
    
  loadURL: (url) =>
    @request = $.getJSON(url)
    @request.done (data) =>
      @loadJSON(data)
      @buildChart()
    