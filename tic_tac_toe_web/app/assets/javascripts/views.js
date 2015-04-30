function BoardView() {
  this.boxes = $('li');
  this.computerStart = $('#computer-start');
  this.humanStart = $('#human-start');
}

BoardView.prototype = {
  initialize: function() {
    console.log('boardview initialize');
    this.boxes.empty();

    // console.log(this.computerStart);
    // console.log(this.humanStart);

    console.log('boardview end');
  }
}
