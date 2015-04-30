$(document).ready( function() {
  controller.run();
})

var board = new Board();
var view = new View();
var controller = new Controller(board, view);
