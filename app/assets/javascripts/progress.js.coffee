class @Progress
  constructor: (@msg, @percent) ->
    @percent ||= 0
    @progress = $('<div class="progress-popup">
      <div class="progress progress-striped active">
        <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 100%;">
          <span class="">' + @msg + '</span>
        </div>
      </div>
    </div>')
    
    $('body').append(@progress)
    
  next: =>
    @percent += 10
    @percent = 0 if @percent > 100
    # @update(@percent)
    
  update: (percent) =>
    @progress.find('.progress-bar').css('width', "#{percent}%")
  
  
  done: =>
    @progress.fadeOut();