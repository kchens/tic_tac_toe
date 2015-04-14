class GameModel
  attr_reader :board, :current_player

  def initialize(first_player_factory, second_player_factory)
    # create a board with nums 0-8
    @board = Array.new(9) { |num| num }
    @player_one = first_player_factory.new(self, "X")
    @player_two = second_player_factory.new(self, "O")
  end

  def current_player
    @current_player ||= @player_one
  end

  def switch_players
    @current_player = @player_two
  end

  def get_available_positions
    board.select {|cell| cell != "X" && cell != "O"}
  end

  def set_position
  end

  def winner?
  end

  def get_winning_states
  end

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
    board = Array.new(9) { |num| num }
  end
end


class Player
  attr_reader :marker
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
p game_model.get_rows       == [[0,1,2], [3,4,5], [6,7,8]]
p game_model.get_columns    == [[0,3,6], [1,4,7], [2,5,8]]
p game_model.get_diagonals  == [[0,4,8], [2,4,6]]
game_model.board[1]         = "X"
p game_model.get_available_positions == [0,2,3,4,5,6,7,8]
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

