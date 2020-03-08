function init_draggables_and_droppables() { 
      $('.piece').draggable({
        containment: '.gameboard',
        snap: '.tile',
        cursor: 'crosshair',
        scroll: false,
        revert: 'invalid'
      });

      $('.tile').droppable({
        drop: function( event, ui ) {
          piece_id = ui.draggable.data('piece-id')
          x_position = $(this).data('x-coord')
          y_position = $(this).data('y-coord')
          $.ajax({
            url: `/pieces/${piece_id}?x_position=${x_position}&y_position=${y_position}`,
            type: 'PUT'
          });
        }
      });
    }
  
  $(function() {
    init_draggables_and_droppables();
  });

  var pusher = new Pusher('b18dd5305d4de3468d37', {
      cluster: 'mt1',
      forceTLS: true
  });

  var gameId = $('.pusherInfo').data('pusherinfo');

  var channel = pusher.subscribe('gameId');

  channel.bind('update-piece', function(data) {
    location.reload(true);
  });