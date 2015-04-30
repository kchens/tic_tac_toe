function BoardModel() {
  this.startHuman;
  this.winner;
  this.tie;
  this.players;
  this.boardPositions;
}

BoardModel.prototype = {
  initialize: function() {
    this.boardPositions = [0,1,2,3,4,5,6,7,8];
  }
}