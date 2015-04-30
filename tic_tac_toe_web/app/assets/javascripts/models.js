function BoardModel() {
  this.positions;
  this.startHuman;
}

BoardModel.prototype = {
  initialize: function() {
    this.positions = [0,1,2,3,4,5,6,7,8];
  }
}