require 'pp'
require 'byebug'

class Board

  def initialize(positions = nil)
    @positions = positions || Array.new(9) {|num| num }
  end

  # attr_reader :positions
  def positions
    @positions
  end

  def full?
    positions.all? {|position| position.is_a?(String) }
  end

  def blank_spaces
    positions.select {|position| position.is_a?(Integer)}
  end

  def rows
    positions.each_slice(3).to_a
  end

  def columns
    rows.transpose
  end

  def diagonals
    diagonals = []
    diagonals << 3.times.map { |num| positions[num *= 4] }
    diagonals << 3.times.map { |num| positions[(num += 1) * 2] }
    diagonals
  end

  def place_piece(chosen_index, marker)
    new_positions = Array.new(positions)
    new_positions[chosen_index] = marker
    return Board.new( new_positions )
  end
end


class Player
  def initialize(marker)
    @marker = marker
  end

  # attr_reader :marker

  def marker
    @marker
  end
end

class HumanPlayer < Player

  def move(board)
    chosen_index = gets.to_i
    board.place_piece(chosen_index, marker)
  end
end


class ComputerPlayer < Player
end


class Game
  def initialize(board_factory, player_one_factory, player_two_factory)
    @board = board_factory.new

    player_one = player_one_factory.new("X")
    player_two = player_two_factory.new("O")

    @players = [player_one, player_two]
    @current_player_id = 0
  end

  def board
    @board
  end

  def players
    @players
  end

  def current_player
    players[@current_player_id]
  end

  def play
    until game_over?(board)
      @board = current_player.move(board)
      if winner?(board)
        VIEW.print_winner(current_player.marker)
      elsif tie?(board)
        VIEW.print_tie
      else
        switch_players!
      end
      VIEW.print_board(board)
      VIEW.print_players_turn(current_player.marker)
    end
  end

  def game_over?(board)
    winner?(board) || tie?(board)
  end

  def winner?(board)
    positions = board.positions

    # get the board's positions
    # check rows - return true and assign @winner
    # check columsn - return true and assign @winner
    # check diagonals - return true and assign @winner
    # otherwise return false
  end

  def tie?(board)
    if board.full? && !@winner
      true
    else
      false
    end
  end

  def switch_players!
    @current_player_id = (@current_player_id == 0) ? 1 : 0
  end

end


class View
  def print_board(game_model)
    cells = game_model.positions
    puts " #{cells[0]}| #{cells[1]}| #{cells[2]}"
    puts "--+---+--"
    puts " #{cells[3]}| #{cells[4]}| #{cells[5]}"
    puts "--+---+--"
    puts " #{cells[6]}| #{cells[7]}| #{cells[8]}"
  end

  def print_players_turn(player_marker)
    puts "It's #{player_marker}'s turn."
  end

  def print_winner(winning_marker)
    puts "Player #{winning_marker} won!"
  end

  def pritn_tie
    puts "TIE!"
  end
end


# TESTING


p "TEST BOARD"
board = Board.new
new_board = board.place_piece(0, "X")


p "Places piece on new board"
p board.positions != new_board
p "Get Rows"
p board.rows == [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
p "Get Columns"
p board.columns == [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
p "Get Diagonals"
p board.diagonals == [[0, 4, 8], [2, 4, 6]]
p "Gets Available Positions"
p board.blank_spaces == [0,1,2,3,4,5,6,7,8]
p board.positions
p board.full? == false

# DELETE
# p "Winning Board?"
# new_board = new_board.place_piece(1, "X")
# new_board = new_board.place_piece(2, "X")
# p new_board.winner? == true

p "Tie board?"

new_board = Board.new(["X","O","X","X","O","O","O","X","O"])
# byebug
# p new_board.tie? == true



# p "Make a game where a human wins"
# VIEW = View.new
my_game = Game.new(Board, HumanPlayer, HumanPlayer)
byebug
p "yo"

# my_game.play