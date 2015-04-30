function View() {
  this.boxes = $('li');
  // this.computerStart = $('#computer-start');
  // this.humanStart = $('#human-start');
  this.startButtons = $('#start-game');
}

View.prototype = {
  clearBoard: function() {
    this.boxes.empty();
  },
  renderBoard: function(boardPositions) {
    this.boxes.each(function(index) {
      var positionValue = boardPositions[index];
      if (typeof positionValue == "string" || positionValue instanceof String) {
        $(this).text( positionValue );
      };
    });
  },
}
