class HumanPlayer < Player
  # has_many :games
  # has_many :boards, through: :games

  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def move(board)
    chosen_index = gets.to_i
    board.place_piece(chosen_index, marker)
  end
end
