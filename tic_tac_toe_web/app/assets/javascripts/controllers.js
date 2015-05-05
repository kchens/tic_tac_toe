function Controller(Board, View) {
  this.board = Board;
  this.view = View;
  this.numGames = 0;
}

Controller.prototype = {
  run: function() {
    this.view.board.show();
    this.updateView();
    this.bindEventListenersToStart();
  },
  updateView: function() {
    this.view.clearBoard();
    this.view.hideWinner();

    // this.view.renderBoard( this.board.positions );
    this.view.renderKanyeTaylorBoard( this.board.positions );

    this.view.removeListenersFromTakenPositions(this.board.positions);
  },
  bindEventListenersToStart: function() {
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
      url: '//localhost:3000/game/',
      type: 'POST',
      dataType: 'json',
      data: gameType
    })
    .done(function(serverData) {

      self.numGames++;

      self.board.initialize(serverData);
      self.view.changeButtonsToRestart();
      self.updateView();
      self.addMove();

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

    self.view.board.on('click', 'td[data-open=true]', function(e) {
      console.log("------------------------");
      self.view.board.off('click');

      $(e.target).text( self.board.players.currentPlayer );
      var chosenIndex;
      var chosenIndexData;

      chosenIndex = e.target.id;
      chosenIndexData = {'chosenIndex': chosenIndex };

      self.view.setDataToFalse(chosenIndex);

      $.ajax({
        url: '//localhost:3000/game/' + self.numGames +'/edit',
        type: 'GET',
        dataType: 'json',
        data: chosenIndexData
      })
      .done( function(serverData) {
        self.board.initialize(serverData);
        self.updateView();

        self.alertWinnerOrTie();
        self.addComputerMove();

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
      url: '//localhost:3000/game/' + self.numGames +'/edit',
      type: 'GET',
      dataType: 'json',
      data: fakeChosenIndexData
    })
    .done( function(serverData) {
      self.board.initialize(serverData);
      self.updateView();


      self.addMove();
      self.alertWinnerOrTie();
    })
    .fail( function(serverData) {
      alert("Failed to render COMPUTER move.");
    })
  },
  alertWinnerOrTie: function() {
    if ( this.board.over ) {
      // if ( this.board.tie ) {
        // alert("Tie: " + this.board.tie );
      // }
      // alert("Winner is: " + this.board.winner());
      this.view.removeListenersFromAllPositions();
      this.view.renderWinner(this.board.winner, this.board.tie);
      this.view.board.off('click');
    }
  },
}
