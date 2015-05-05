function View() {
  this.board = $('#board');
  this.openBoxes = $('td[data-open=true]');
  this.boxes = $('td');

  this.startButtons = $('#start-game').children();
  this.startComputerButton = $('#computer-start')
  this.startHumanButton = $('#human-start')

  this.gameOverDiv = $('#game-over');
  this.winnerHeading = $('#winner');
  this.tieHeading = $('#tie');
  this.kanyeWinImg = $('#kanye-win');
  this.taylorWinImg = $('#taylor-win');

  this.kanyeImgs = "<img class='kanye img-rounded' src='https://raw.githubusercontent.com/kchens/kchens.github.io/master/images/ttt-kanye.png'>"
  this.taylorImgs = "<img class='taylor img-rounded' src='https://raw.githubusercontent.com/kchens/kchens.github.io/master/images/ttt-taylor.png'>"
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
      if (typeof positionValue === "string" || positionValue instanceof String) {
        $(this).text( positionValue );
        // console.log("chosen index" + index)
        self.setDataToFalse(index);
      };
    });
  },
  renderKanyeTaylorBoard: function(boardPositions) {
    var self = this;
    self.boxes.each(function(index) {
      var positionValue = boardPositions[index];
      if (positionValue === "X") {
        $(this).append(self.taylorImgs);
        self.setDataToFalse(index);
      } else if (positionValue === "O") {
        $(this).append(self.kanyeImgs);
        self.setDataToFalse(index);
      }
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
        // console.log("remove listeners from taken positions: " + index);
        self.removeEventListener(index);
      };
    });
  },
  removeListenersFromAllPositions: function() {
    var self = this;
    self.boxes.each(function(index) {
      self.removeEventListener(index);
    });
  },
  addEventListeners: function(boardOpenPositions) {},
  changeButtonsToRestart: function() {
    this.startComputerButton.text("Restart Computer");
    this.startHumanButton.text("Restart Human");
  },
  renderWinner: function(winningMarker, tieBoolean) {
    this.gameOverDiv.show();
    if ( winningMarker == "X" ) {
      this.winnerHeading.show();
      this.taylorWinImg.show();
    } else if ( winningMarker == "O") {
      this.winnerHeading.show();
      this.kanyeWinImg.show();
    } else if ( tieBoolean ) {
      this.tieHeading.show();
      this.kanyeWinImg.show();
    }
  },
  hideWinner: function() {
    this.gameOverDiv.hide();
    this.kanyeWinImg.hide();
    this.taylorWinImg.hide();

    this.winnerHeading.hide();
    this.tieHeading.hide();
  }
}
