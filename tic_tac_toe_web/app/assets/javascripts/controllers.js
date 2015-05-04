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
      self.view.changeButtonsToRestart();

      self.addMove();

    })
    .fail(function(serverData) {
      console.log("Failed to Start Game");
    });
  },
  isGameOver: function() {
    return this.board.gameStatus.over;
  },
  addMove: function() {
    var self = this;

    this.view.boxes.on('click', function(e){
      $(e.target).text( self.board.players.currentPlayer );
      var chosenIndex;
      var chosenIndexData;

      chosenIndex = e.target.id;
      chosenIndexData = {'chosenIndex': chosenIndex };

      self.view.setDataToFalse(chosenIndex);
      self.view.removeEventListener(chosenIndex);

      $.ajax({
        url: 'http://localhost:3000/game/' + self.numGames +'/edit',
        type: 'GET',
        dataType: 'json',
        data: chosenIndexData
      })
      .done( function(serverData) {
        self.board.initialize(serverData);
        self.updateView();

        self.addComputerMove();

        //
        console.log("Is there a winner?--------" + self.board.thereIsAWinner());
        if ( self.board.thereIsAWinner() ) {
          alert("Winner is: " + self.board.winner());
        } else {
          alert("No winner: " + self.board.winner());
        }
        //

      })
      .fail( function(serverDat) {
        alert("Failed to render HUMAN move.");
      });
    });
  },
  addComputerMove: function() {
    var self = this;
    var fakeChosenIndexData = {'chosenIndex': null };

    $.ajax({
      url: 'http://localhost:3000/game/' + self.numGames +'/edit',
      type: 'GET',
      dataType: 'json',
      data: fakeChosenIndexData
    })
    .done( function(serverData) {
      self.board.initialize(serverData);
      self.updateView();


      //
      console.log("Is there a winner?--------" + self.board.thereIsAWinner());
      if ( self.board.thereIsAWinner() ) {
        alert("Winner is: " + self.board.winner());
      } else {
        alert("No winner: " + self.board.winner());
      }
      //

    })
    .fail( function(serverData) {
      alert("Failed to render COMPUTER move.");
    })
  }
}
