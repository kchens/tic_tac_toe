require 'pp'
require 'byebug'

class Board
  attr_reader :positions

  def initialize
    @positions = Array.new(9) {|num| num }
  end

  def full?
    @positions.all? {|position| position.is_a?(String) }
  end

  def blank_spaces
    @positions.select {|position| position.is_a?(Integer)}
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
    new_positions
  end
end

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

class Player

  attr_reader :game, :marker

  def initialize(game, marker)
    @game   = game
    @marker = marker
  end

end

class HumanPlayer < Player

  def set_position

  end

end


class ComputerPlayer < Player

  def set_position
    game.set_position(rand(9))
  end

end

class Game

end

class View
  def print_board(game_model)
    cells = game_model.board
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
end