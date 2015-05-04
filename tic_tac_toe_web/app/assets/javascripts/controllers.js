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
    this.view.board.show();
    this.view.clearBoard();
    this.view.hideWinner();
    // this.view.renderBoard( this.board.positions );
    this.view.renderKanyeTaylorBoard( this.board.positions );

    this.view.removeListenersFromTakenPositions(this.board.positions);

  },
  bindEventListeners: function() {
    var self = this;

    $(this.view.startButtons).on('click', function(e){
      self.view.clearBoard();
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
      self.view.changeButtonsToRestart();
      self.updateView();
      self.addMove()

    })
    .fail(function(serverData) {
      alert("Failed to Start Game");
    });
  },
  isGameOver: function() {
    return this.board.gameStatus.over;
  },
  addMove: function() {
    var self = this;

    self.view.boxes.on('click', function(e){
      $(e.target).text( self.board.players.currentPlayer );
      var chosenIndex;
      var chosenIndexData;

      chosenIndex = e.target.id;
      chosenIndexData = {'chosenIndex': chosenIndex };

      self.view.setDataToFalse(chosenIndex);
      // self.view.removeEventListener(chosenIndex);

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

        self.alertWinnerOrTie();
      })
      .fail( function(serverData) {
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

      self.alertWinnerOrTie();

    })
    .fail( function(serverData) {
      alert("Failed to render COMPUTER move.");
    })
  },
  alertWinnerOrTie: function() {
    if ( this.board.gameIsOver() ) {
      // if ( this.board.thereIsATie() ) {
        // alert("Tie: " + this.board.thereIsATie() );
      // }
      // alert("Winner is: " + this.board.winner());
      this.view.removeListenersFromAllPositions();
      // this.view.board.hide();
      this.view.renderWinner(this.board.winner(), this.board.thereIsATie());
    }
  },
}
