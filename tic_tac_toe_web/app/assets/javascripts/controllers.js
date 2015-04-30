function Controller(boardModel, boardView) {
  this.boardModel = boardModel;
  this.boardView = boardView;
}

Controller.prototype = {
  initialize: function() {
    console.log("In controller");
    console.log("board Model positions: " + this.boardModel.positions);
    console.log("board View boxes: ");
    this.boardView.initialize();
  },
  run: function() {
    this.initialize();
  }
}