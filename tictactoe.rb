class GameModel
  attr_reader :board, :current_player

  def initialize(first_player_factory, second_player_factory)
    # create a board with nums 0-8
    @board = Array.new(9) { |num| num }
    @player_one = first_player_factory.new(self, "X")
    @player_two = second_player_factory.new(self, "O")
    @current_player = @player_one
  end

  def switch_players!
    @current_player = (@current_player.marker == @player_one.marker) ? (@player_two) : (@player_one)
  end

  def get_available_positions
    board.select {|cell| cell != "X" && cell != "O"}
  end

  def set_position!(num)
    board[num] = @current_player.marker
  end

  def return_winner
    @current_player.marker if winner?
  end

  def winner?
    win_filter = Proc.new { |array| return true if array.uniq.count == 1 }

    get_rows.each(&win_filter)
    get_columns.each(&win_filter)
    get_diagonals.each(&win_filter)

    # get_rows.each       {|row| return true if row.uniq.count == 1 }
    # get_columns.each    {|column| return true if column.uniq.count == 1 }
    # get_diagonals.each  {|diagonal| return true if diagonal.uniq.count == 1 }
    return false
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

  def set_position!(num)
    if game.get_available_positions.include?(num)
      game.set_position!(num)
      game.switch_players!
    else
      false
    end
  end
end


# class GameController

#   def initialize(args = {player_one: Player.new, player_two: Player.new, game_model: GameModel.new, view: GameView.new})
#     game_model = args[:game_model]
#     view       = args[:view]
#   end

#   def set_position
#     selected_position = view.set_position
#     game_model(selected_position)
#   end
# end


class GameView
  def initialize
  end

  def print_board(game_model)
    cells = game_model.board
    puts " #{cells[0]}| #{cells[1]}| #{cells[2]}"
    puts "--+---+--"
    puts " #{cells[3]}| #{cells[4]}| #{cells[5]}"
    puts "--+---+--"
    puts " #{cells[6]}| #{cells[7]}| #{cells[8]}"
  end

  def print_winner
  end

  def set_position
    puts "Select a position"
    gets
  end

end


board_checker = Array.new(9) { |num| num }
game_model = GameModel.new(HumanPlayer, HumanPlayer)
view = GameView.new

# controller = GameController.new({game_model})


p game_model.current_player.marker  == "X"
game_model.switch_players!
p game_model.current_player.marker  == "O"
game_model.switch_players!
p game_model.current_player.marker  == "X"

p game_model.get_rows       == [[0,1,2], [3,4,5], [6,7,8]]
p game_model.get_columns    == [[0,3,6], [1,4,7], [2,5,8]]
p game_model.get_diagonals  == [[0,4,8], [2,4,6]]
game_model.board[1]         = "X"
p game_model.get_available_positions == [0,2,3,4,5,6,7,8]
p game_model.clear_board    == board_checker
game_model.current_player.set_position!(0)
p game_model.board          == ["X",1,2,3,4,5,6,7,8]
p game_model.clear_board    == board_checker
# p game_model.switch_players!

# Win Row
p "Row--"
game_model.current_player.set_position!(0)
game_model.current_player.set_position!(5) #other player
game_model.current_player.set_position!(1)
game_model.current_player.set_position!(7) #other player
game_model.current_player.set_position!(2)
# p view.print_board(game_model)
p game_model.clear_board    == board_checker

# Win Column
p "Column--"
game_model.current_player.set_position!(0)
game_model.current_player.set_position!(1) #other player
game_model.current_player.set_position!(3)
game_model.current_player.set_position!(2) #other player
game_model.current_player.set_position!(6)
# p view.print_board(game_model)
p game_model.winner?        == true
p game_model.clear_board    == board_checker

# Win Diagonal
p "Diagonal--"
game_model.current_player.set_position!(0)
game_model.current_player.set_position!(2) #other player
game_model.current_player.set_position!(4)
game_model.current_player.set_position!(6) #other player
game_model.current_player.set_position!(8)
# p view.print_board(game_model)
p game_model.winner?        == true

p "Return Winner --"
p game_model.return_winner  == "X"
p game_model.clear_board    == board_checker

# Unable to move
p "Player unable to move--"
game_model.current_player.set_position!(0)
p game_model.current_player.set_position!(0) == false
