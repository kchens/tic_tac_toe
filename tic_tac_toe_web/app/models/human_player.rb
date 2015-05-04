class HumanPlayer < Player

  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def move(board, chosen_index = nil)
    board.place_piece(chosen_index, marker)
  end
end
