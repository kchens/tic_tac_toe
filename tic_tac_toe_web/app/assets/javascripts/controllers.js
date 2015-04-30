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
      console.log("Success:" + serverData)
    });

    request.fail(function(res) {
      console.log('create reminder fail!')
    });
  },
}
