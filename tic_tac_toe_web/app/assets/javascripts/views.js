function BoardView() {
  this.boxes = $('li');
  // this.computerStart = $('#computer-start');
  // this.humanStart = $('#human-start');
  this.startButtons = $('#start-game');
}

BoardView.prototype = {
  initialize: function() {
    this.boxes.empty();
  },
}
