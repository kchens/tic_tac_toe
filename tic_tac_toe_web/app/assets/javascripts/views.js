function View() {
  this.boxes = $('td');
  // this.computerStart = $('#computer-start');
  // this.humanStart = $('#human-start');

  this.startButtons = $('#start-game').children();

  this.gameOverDiv = $('#game-over');
  this.winnerHeading = $('#winner');
  this.tieHeading = $('#tie');
  this.kanyeImg = $('#kanye');
  this.taylorImg = $('#taylor');
}

View.prototype = {
  clearBoard: function() {
    this.boxes.empty();
    this.resetAllData();
  },
  renderBoard: function(boardPositions) {
    var self = this;
    self.boxes.each(function(index) {
      var positionValue = boardPositions[index];
      if (typeof positionValue == "string" || positionValue instanceof String) {
        $(this).text( positionValue );
        console.log("chosen index" + index)
        self.setDataToFalse(index);
      };
    });
  },
  resetAllData: function() {
    this.boxes.each(function(index) {
      $(this).attr('data-open', 'true');
    });
  },
  setDataToFalse: function(chosenIndex) {
    $('#' + chosenIndex).attr('data-open', false);
  },
  removeEventListener: function(chosenIndex) {
    $('#' + chosenIndex).off('click');
  },
  removeListenersFromTakenPositions: function(boardPositions) {
    var self = this;
    self.boxes.each(function(index) {
      var positionValue = boardPositions[index];
      if (typeof positionValue == "string" || positionValue instanceof String) {
        console.log("remove listeners from taken positions: " + index);
        self.removeEventListener(index);
      };
    });
  },
  removeListenersFromAllPositions: function(boardPositions) {
    var self = this;
    self.boxes.each(function(index) {
      self.removeEventListener(index);
    });
  },
  addEventListeners: function(boardOpenPositions) {},
  changeButtonsToRestart: function() {
    console.log("Start buttons------" + this.startButtons);
    $(this.startButtons[0]).text("Restart Computer");
    $(this.startButtons[1]).text("Restart Human");
  },
  renderWinner: function(winningMarker, tieBoolean) {
    this.gameOverDiv.show();
    if ( winningMarker == "X" ) {
      this.winnerHeading.show();
      this.taylorImg.show();
    } else if ( winningMarker == "O") {
      this.winnerHeading.show();
      this.kanyeImg.show();
    } else if ( tieBoolean ) {
      this.tieHeading.show();
      this.kanyeImg.show();
    }
  },
  hideWinner: function() {
    this.gameOverDiv.hide();
    this.kanyeImg.hide();
    this.taylorImg.hide();

    this.winnerHeading.hide();
    this.tieHeading.hide();
  }

  // availablePositions: function(chosenIndex) {
  //   var newPositions = [];
  //   $('#' + chosenIndex).attr('data-open', false);
  // },
  // removeEventListeners: function(){}
}
