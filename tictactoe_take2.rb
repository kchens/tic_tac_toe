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

  def get_available_positions
    positions.select {|cell| cell != "X" && cell != "O"}
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

  def game_over?
    @winner || tie?
  end

  def winner?
    win_filter = Proc.new do |line|
      unique_markers = line.uniq
      if unique_markers.count == 1
        @winner = unique_markers[0]
        return true
      end
    end

    rows.each(&win_filter)
    columns.each(&win_filter)
    diagonals.each(&win_filter)
    return false
  end

  def winner
    @winner
  end

  def tie?
    if full? && !@winner
      true
    else
      false
    end
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
  def move(board)
    minmax(board) #minmax to create @best_move

    board.place_piece(@best_move, marker)
  end

  # minmax
  # call minmax(board)
  #   minmax
        # else
        #   player_tracker = player_tracker.nil? ? 0 : counter + 1
        #   new_marker = counter.even? ? 'X' : 'O'

  def minmax(board) #minmax
    if board.game_over?
      # byebug
      return score(board)
    else
      worst_score = (1.0/0.0) #Infinity
      best_score  = -worst_score #-Infinity
      @best_move   = nil

      player_tracker = player_tracker.nil? ? 0 : counter + 1
      new_marker = player_tracker.even? ? 'O' : 'X'

      board.get_available_positions.each do |move|
        board = board.place_piece(move, new_marker)
        # other_player_marker = (marker == 'O') ? 'X' : 'O'
        # byebug
        current_score = minmax(board)

        if current_score > best_score
          @best_move = move
          best_score = current_score
          return best_score
        # elsif current_score < worst_score && new_marker != marker
        #   @best_move = move
        #   worst_score = current_score
        #   return worst_score
        end
      end
    end
    #   score the game
    #   retrun the score
    # else
    #   keep track of best_score and best_mvoe
    #   loop through games positions
    #     current_score = minmax(board.place_piece(best_move, move))
  end

  def score(board)
    if board.winner == marker
      10
    elsif board.winner != marker
      -10
    else
      0
    end
  end
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
    VIEW.print_board(board)
    until board.game_over?
      @board = current_player.move(board)
      VIEW.print_board(board)
      if board.winner?
        return VIEW.print_winner(board.winner)
      elsif board.tie?
        return VIEW.print_tie
      else
        switch_players!
        VIEW.print_players_turn(current_player.marker)
      end
    end
  end

  # def game_over?(board)
  #   @winner || tie?(board)
  # end

  # def winner?(board)
  #   win_filter = Proc.new do |line|
  #     unique_markers = line.uniq
  #     if unique_markers.count == 1
  #       @winner = unique_markers[0]
  #       return true
  #     end
  #   end

  #   board.rows.each(&win_filter)
  #   board.columns.each(&win_filter)
  #   board.diagonals.each(&win_filter)
  #   return false
  # end

  # def tie?(board)
  #   if board.full? && !@winner
  #     true
  #   else
  #     false
  #   end
  # end

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

  def print_tie
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

winning_board = Board.new(["X","O","O","X","O","O","X",7,8])

# p "Make a game where a human wins"

VIEW = View.new
my_game = Game.new(Board, HumanPlayer, ComputerPlayer)
# byebug
p "yo"

my_game.play

