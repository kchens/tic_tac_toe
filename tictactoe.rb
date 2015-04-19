require 'pp'
require 'byebug'

module TicTacToe
  class GameModel
    # attr_reader :current_player
    attr_accessor :board, :player_one, :player_two, :current_player

    def initialize(first_player_factory, second_player_factory)
      # create a board with nums 0-8
      new_board
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

    def set_position(chosen_pos)
      board[chosen_pos] = @current_player.marker
    end

    def return_winning_marker
      # switch_players!
      @current_player.marker if winner?
    end

    def over?
      winner? || tie?
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

    def get_corners
      [0,2,3,5,6,8]
    end

    def get_final_move
      return get_available_positions.first if get_available_positions.count == 1
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

    def tie? #full_board?
      get_available_positions.any? ? false : true
    end

    def unplayed?
      board.all? {|space| space.is_a?(Fixnum) }
    end

    def new_board
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

    def set_position!
      chosen_pos = gets.to_i
      if game.get_available_positions.include?(chosen_pos)
        game.set_position(chosen_pos)
        # game.switch_players!
      else
        return false
      end
    end
  end

  class ComputerPlayer < Player

    INITIAL_DEPTH = 0

    Node = Struct.new(:score, :move)

    def set_position!
      return game if game.over?
      game.set_position(choose_move)

      # game.switch_players!
    end

    def choose_move
      # 2. game_state = copy_game_state
      # @game_state = copy_game_state
      game_state = copy_game_state
      # return game_state.get_corners.sample if game_state.unplayed?
      # return game_state.get_final_move if game_state.get_available_positions.count == 1

      best_possible_move(game_state)
    end

    def copy_game_state
      # 1. don't maek this an instance variable
      game_state = game.dup
      game_state.board = game.board.dup
      game_state.current_player = game.current_player.dup
      game_state
    end

    def best_possible_move(game_state)
      # byebug
      # When Human enters 1
      # ["X", "O", 2, 3, "O", 5, 6, 7, 8]
      # marker == "X"
      # => score == 7
      minmax(game_state)
    end

    def minmax(game_state)
      if game_state.over?
        end_score = score(game_state)
        return end_score
      else
        best_score = -(1.0/0.0)
        best_move = nil

        game_state.get_available_positions.each do |move|
          current_score = minmax(apply_move_to_game(game_state, move))
          if current_score > best_score
            best_score = current_score
            best_move = move
          end
        end
      end
      # byebug
      best_move
    end

    def apply_move_to_game(game_state, move)
      child_game = game_state.dup
      child_game.board = game_state.board.dup
      child_game.current_player = game_state.current_player.dup
      child_game.set_position(move)
      child_game.switch_players!
      child_game
    end

    def score(end_game)
      if end_game.return_winning_marker == marker
        10
      elsif end_game.return_winning_marker != marker
        -10
      else
        0
      end
    end
  end

  class GameController

    def initialize(args = {player_one_type: HumanPlayer, player_two_type: ComputerPlayer})
      @game_model = GameModel.new(args[:player_one_type], args[:player_two_type])
      @view       = GameView.new
      print_view
    end

    def play
      loop do
        return if over?
        add_move
        print_view
      end
    end

    def add_move
      valid_move = false
      until valid_move
        # chosen_pos = @view.asks_for_position
        @game_model.current_player.set_position! ? (valid_move = true) : @view.says_position_unavailable
      end
      @game_model.switch_players!
      @view.print_players_turn(@game_model.current_player.marker)
    end

    def over?
      winner? || tie?
    end

    def winner?
      if @game_model.winner?
        @view.print_winner(@game_model.return_winning_marker)
        play_again?
      end
    end

    def tie?
      if @game_model.tie?
        @view.print_tied
        play_again?
      end
    end

    def play_again?
      response = @view.ask_to_play_again
      if response == "Y"
        @game_model.new_board
        print_view
        play
      else
        end_game
      end
    end

    def end_game
      true
    end

    def print_view
      @view.print_board(@game_model)
    end
  end


  class GameView

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

    def print_tied
      puts "You tied."
    end

    def asks_for_position
      puts "Select a position"
      gets.to_i
    end

    def says_position_unavailable
      puts "Unavailable position, choose another"
    end

    def ask_to_play_again
      response = nil
      until response == 'Y' || response == 'N'
        puts 'Play again? (Y/N)'
        response = gets.chomp.upcase
      end
      response
    end
  end
end

# board_checker = Array.new(9) { |num| num }
# human_game = TicTacToe::GameModel.new(TicTacToe::HumanPlayer, TicTacToe::HumanPlayer)
VIEW = TicTacToe::GameView.new

# # controller = GameController.new({human_game})


# p human_game.current_player.marker  == "X"
# human_game.switch_players!
# p human_game.current_player.marker  == "O"
# human_game.switch_players!
# p human_game.current_player.marker  == "X"

# p "Get Rows--"
# p human_game.get_rows       == [[0,1,2], [3,4,5], [6,7,8]]

# p "Get Columns--"
# p human_game.get_columns    == [[0,3,6], [1,4,7], [2,5,8]]

# p "Get Diagonals--"
# p human_game.get_diagonals  == [[0,4,8], [2,4,6]]
# human_game.board[1]         = "X"

# p "Get Available Positions--"
# p human_game.get_available_positions == [0,2,3,4,5,6,7,8]

# p "Clear Board--"
# p human_game.new_board    == board_checker

# p "Set Position--"
# p "---Enter 0"
# human_game.current_player.set_position!
# p human_game.board          == ["X",1,2,3,4,5,6,7,8]
# human_game.new_board

# # Win Row
# p "Row--"
# p "---Enter 0,5,1,7,2"
# human_game.current_player.set_position!#(0)
# human_game.current_player.set_position!#(5) #other player
# human_game.current_player.set_position!#(1)
# human_game.current_player.set_position!#(7) #other player
# human_game.current_player.set_position!#(2)
# # p view.print_board(human_game)
# p human_game.new_board    == board_checker

# # Win Column
# p "Column--"
# p "---Enter 0,1,3,2,6"
# human_game.current_player.set_position!#(0)
# human_game.current_player.set_position!#(1) #other player
# human_game.current_player.set_position!#(3)
# human_game.current_player.set_position!#(2) #other player
# human_game.current_player.set_position!#(6)
# # p view.print_board(human_game)
# p human_game.winner?        == true
# human_game.new_board    == board_checker

# # Win Diagonal
# p "Diagonal--"
# p "---Enter 0,2,4,6,8"
# human_game.current_player.set_position!#(0)
# human_game.current_player.set_position!#(2) #other player
# human_game.current_player.set_position!#(4)
# human_game.current_player.set_position!#(6) #other player
# human_game.current_player.set_position!#(8)
# # p view.print_board(human_game)
# p human_game.winner?        == true

# p "Return Winner --"
# p human_game.return_winner  == "O"
# p view.print_board(human_game)
# human_game.new_board    == board_checker

# p "Return Tie --"
# p "---Enter 0,1,2,4,7,3,6,8,5"
# human_game.current_player.set_position!#(0)
# human_game.current_player.set_position!#(1) #other player
# human_game.current_player.set_position!#(2)
# human_game.current_player.set_position!#(4) #other player
# human_game.current_player.set_position!#(7) #other player
# human_game.current_player.set_position!#(3)
# human_game.current_player.set_position!#(6)
# human_game.current_player.set_position!#(8)
# human_game.current_player.set_position!#(5)
# p human_game.winner?        == false
# p human_game.tie?        == true

# p "Check if board reset"
# p view.print_board(human_game)
# human_game.new_board
# p view.print_board(human_game)

# Unable to move
# p "Player unable to move--until you enter an available number (not 0)"
# human_game.current_player.set_position!(0)
# human_game.current_player.set_position!(0)
# p view.print_board(human_game)

p "Lets play!"
my_game = TicTacToe::GameController.new
my_game.play

# p "Testing Computer Game---"

# computer_game = TicTacToe::GameModel.new(TicTacToe::HumanPlayer, TicTacToe::ComputerPlayer)
# view = TicTacToe::GameView.new
# view.print_board(computer_game)

# p "---Unplayed"
# p computer_game.unplayed? == true

# my_computer_game = TicTacToe::GameController.new
# my_computer_game.play

# computer_game.current_player.set_position!
# view.print_board(computer_game)
# computer_game.current_player.set_position!
# view.print_board(computer_game)
