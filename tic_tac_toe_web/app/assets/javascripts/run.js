$(document).ready( function() {
  controller.run();
})

var boardModel = new BoardModel();
var boardView = new BoardView();
var controller = new Controller(boardModel, boardView);