function View() {
  this.boxes = $('td');
  // this.computerStart = $('#computer-start');
  // this.humanStart = $('#human-start');

  this.startButtons = $('#start-game').children();
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
  addEventListeners: function(boardOpenPositions) {},
  changeButtonsToRestart: function() {
    console.log("Start buttons------" + this.startButtons);
    $(this.startButtons[0]).text("Restart Computer");
    $(this.startButtons[1]).text("Restart Human");
  }

  // availablePositions: function(chosenIndex) {
  //   var newPositions = [];
  //   $('#' + chosenIndex).attr('data-open', false);
  // },
  // removeEventListeners: function(){}
}
