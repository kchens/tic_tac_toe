function Controller(Board, View) {
  this.board = Board;
  this.view = View;
}

Controller.prototype = {
  run: function() {
    this.updateView();
    this.bindEventListeners();
  },
  updateView: function() {
    this.view.clearBoard();
    this.view.renderBoard( this.board.positions );
  },
  bindEventListeners: function() {
    var self = this;
    $(this.view.startButtons).on('click', function(e){
      var gameType = $(e.target).data();
      self.startGame(gameType);
    })
  },
  startGame: function(gameType) {
    var self = this;
    var request = $.ajax({
      type: 'POST',
      url: 'http://localhost:3000/game/',
      dataType: 'json',
      data: gameType
    });

    request.done(function(serverData) {
      self.board.initialize(serverData);
      self.updateView();
    });

    request.fail(function(serverData) {
      console.log("Failed to Start Game");
    });
  },
  isGameOver: function() {
    return this.board.gameStatus.over;
  },
  addMove: function() {

  }
}
