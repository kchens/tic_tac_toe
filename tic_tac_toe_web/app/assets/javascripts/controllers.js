function Controller(boardModel, boardView) {
  this.boardModel = boardModel;
  this.boardView = boardView;
}

Controller.prototype = {
  run: function() {
    this.initialize();
    this.bindEventListeners();
  },
  initialize: function() {
    this.boardView.initialize();
    this.boardModel.initialize();
  },
  bindEventListeners: function() {
    var self = this;
    $(this.boardView.startButtons).on('click', function(e){
      var gameType = $(e.target).data();
      self.startGame(gameType);
    })
  },
  startGame: function(gameType) {
    var request = $.ajax({
      type: 'POST',
      url: 'http://localhost:3000/game/',
      dataType: 'json',
      data: gameType
    });

    request.done(function(serverData) {
      console.log(serverData.winner);
      console.log(serverData.tie);
      console.log(serverData.players);
      console.log(serverData.players.human_player);
      console.log(serverData.players.computer_player);
      console.log(serverData.board.positions);
    });

    request.fail(function(serverData) {
      console.log("Failed to Start Game");
    });
  },
}
