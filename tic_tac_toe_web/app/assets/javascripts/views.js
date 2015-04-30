function BoardView() {
  this.boxes = $('li');
}

BoardView.prototype = {
  initialize: function() {
    console.log("--------");
    Array.prototype.forEach.call(this.boxes, function(box) {
      console.log(box);
    })
  },
}
