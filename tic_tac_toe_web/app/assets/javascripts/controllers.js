function Controller(Board, View) {
  this.board = Board;
  this.view = View;
  this.numGames = 0;
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
    });
  },
  startGame: function(gameType) {
    var self = this;
    $.ajax({
      url: 'http://localhost:3000/game/',
      type: 'POST',
      dataType: 'json',
      data: gameType
    })
    .done(function(serverData) {

      self.numGames++;

      self.board.initialize(serverData);
      self.updateView();

      if ( !self.board.gameStatus.over) {
        self.addMove();
      }

    })
    .fail(function(serverData) {
      console.log("Failed to Start Game");
    });
  },
  isGameOver: function() {
    return this.board.gameStatus.over;
  },
  addMove: function() {
    var chosenIndex;
    var data;
    var self = this;
    this.view.boxes.on('click', function(e){
      $(e.target).text( self.board.players.currentPlayer );
      chosenIndex = e.target.id;

      chosenIndexData = {'chosenIndex': chosenIndex };

      console.log(chosenIndexData);

      $.ajax({
        url: 'http://localhost:3000/game/+' + self.numGames +'/edit',
        type: 'GET',
        dataType: 'json',
        data: chosenIndexData
      })
      .done( function(serverData) {
        console.log("-------");
        console.log(serverData.board.positions);
        console.log("-------");
      })
      .fail( function(serverDat) {
        console.log(serverData);
      });
    });


    // make ajax request to back-end
    // get back new server data
    // render it
  }
}
