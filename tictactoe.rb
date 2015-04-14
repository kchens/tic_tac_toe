class GameModel
  attr_reader :board, :current_player

  def initialize(first_player_factory, second_player_factory)
    # create a board with nums 0-8
    @board = Array.new(9) { |num| num }
    @player_one = first_player_factory.new(self, "X")
    @player_two = second_player_factory.new(self, "O")
    @current_player = @player_one
  end

  def switch_players
    @current_player = (@current_player.marker == @player_one.marker) ? (@player_two) : (@player_one)
  end

  def get_available_positions
    board.select {|cell| cell != "X" && cell != "O"}
  end

  def set_position(num)
    board[num] = @current_player.marker
  end

  def winner?
    get_rows.each       {|row| return true if row.uniq.count == 1 }
    get_columns.each    {|column| return true if column.uniq.count == 1 }
    get_diagonals.each  {|diagonal| return true if diagonal.uniq.count == 1 }
    return false
  end

  # def loop_through(nested_array)
  #   nested_array.each |array|
  #     yield array
  #   end
  # end

  def get_rows
    board.each_slice(3).to_a
  end

  def get_columns
    get_rows.transpose
  end

  def get_diagonals
    diagonals = []
    diagonals << 3.times.map { |num| board[num *= 4] }
    diagonals << 3.times.map { |num| board[(num += 1) * 2] }
    diagonals
  end

  def clear_board
    @board = Array.new(9) { |num| num }
  end
end


class Player
  attr_reader :game, :marker
  def initialize(game, marker)
    @game = game
    @marker = marker
  end
end

class HumanPlayer < Player

  def set_position(num)
    game.set_position(num)
  end
end

board_checker = Array.new(9) { |num| num }
game_model = GameModel.new(HumanPlayer, HumanPlayer)

p game_model.current_player.marker  == "X"
game_model.switch_players
p game_model.current_player.marker  == "O"
game_model.switch_players
p game_model.current_player.marker  == "X"

p game_model.get_rows       == [[0,1,2], [3,4,5], [6,7,8]]
p game_model.get_columns    == [[0,3,6], [1,4,7], [2,5,8]]
p game_model.get_diagonals  == [[0,4,8], [2,4,6]]
game_model.board[1]         = "X"
p game_model.get_available_positions == [0,2,3,4,5,6,7,8]
p game_model.clear_board    == board_checker
game_model.current_player.set_position(0)
p game_model.board          == ["X",1,2,3,4,5,6,7,8]

# Win Row
game_model.current_player.set_position(1)
game_model.current_player.set_position(2)
p game_model.winner? == true
p game_model.board
p game_model.clear_board    == board_checker

# Win Column
game_model.current_player.set_position(0)
game_model.current_player.set_position(3)
game_model.current_player.set_position(6)
p game_model.board
p game_model.winner?        == true
p game_model.clear_board    == board_checker

# Win Diagonal
game_model.current_player.set_position(0)
game_model.current_player.set_position(4)
game_model.current_player.set_position(8)
p game_model.board
p game_model.winner?        == true
p game_model.clear_board    == board_checker

class GameController

  def initialize(model = GameModel.new, player_one = Player.new, player_two = Player.new, view = GameView.new)
  end

end


class GameView
  def initialize
  end

  def print_board
  end

  def print_winner
  end

  def get_move
  end

end

