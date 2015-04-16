module TicTacToe
  class GameModel
    attr_reader :board, :current_player

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

    def return_winner
      switch_players!
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

    def tie? #full_board?
      get_available_positions.any? ? false : true
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
        game.switch_players!
      else
        return false
      end
    end
  end


  class GameController

    def initialize(args = {player_one_type: HumanPlayer, player_two_type: HumanPlayer})
      @game_model = GameModel.new(args[:player_one_type], args[:player_two_type])
      @view       = GameView.new
      print_view
    end

    def play
      loop do
        return if calculate_winner
        return if calculate_tie
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
      @view.print_players_turn(@game_model.current_player.marker)
    end

    def calculate_winner
      if @game_model.winner?
        @view.print_winner(@game_model.return_winner)
        end_or_rematch
      end
    end

    def calculate_tie
      if @game_model.tie?
        @view.print_tied
        end_or_rematch
      end
    end

    def end_or_rematch
      response = @view.ask_to_play_again
      if response == "Y"
        @game_model.new_board
        print_view
        play
      else
        !false
      end
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

board_checker = Array.new(9) { |num| num }
game_model = TicTacToe::GameModel.new(TicTacToe::HumanPlayer, TicTacToe::HumanPlayer)
view = TicTacToe::GameView.new

# controller = GameController.new({game_model})


p game_model.current_player.marker  == "X"
game_model.switch_players!
p game_model.current_player.marker  == "O"
game_model.switch_players!
p game_model.current_player.marker  == "X"

p "Get Rows--"
p game_model.get_rows       == [[0,1,2], [3,4,5], [6,7,8]]

p "Get Columns--"
p game_model.get_columns    == [[0,3,6], [1,4,7], [2,5,8]]

p "Get Diagonals--"
p game_model.get_diagonals  == [[0,4,8], [2,4,6]]
game_model.board[1]         = "X"

p "Get Available Positions--"
p game_model.get_available_positions == [0,2,3,4,5,6,7,8]

p "Clear Board--"
p game_model.new_board    == board_checker

# p "Set Position--"
# p "---Enter 0"
# game_model.current_player.set_position!
# p game_model.board          == ["X",1,2,3,4,5,6,7,8]
# game_model.new_board

# # Win Row
# p "Row--"
# p "---Enter 0,5,1,7,2"
# game_model.current_player.set_position!#(0)
# game_model.current_player.set_position!#(5) #other player
# game_model.current_player.set_position!#(1)
# game_model.current_player.set_position!#(7) #other player
# game_model.current_player.set_position!#(2)
# # p view.print_board(game_model)
# p game_model.new_board    == board_checker

# # Win Column
# p "Column--"
# p "---Enter 0,1,3,2,6"
# game_model.current_player.set_position!#(0)
# game_model.current_player.set_position!#(1) #other player
# game_model.current_player.set_position!#(3)
# game_model.current_player.set_position!#(2) #other player
# game_model.current_player.set_position!#(6)
# # p view.print_board(game_model)
# p game_model.winner?        == true
# game_model.new_board    == board_checker

# # Win Diagonal
# p "Diagonal--"
# p "---Enter 0,2,4,6,8"
# game_model.current_player.set_position!#(0)
# game_model.current_player.set_position!#(2) #other player
# game_model.current_player.set_position!#(4)
# game_model.current_player.set_position!#(6) #other player
# game_model.current_player.set_position!#(8)
# # p view.print_board(game_model)
# p game_model.winner?        == true

# p "Return Winner --"
# p game_model.return_winner  == "O"
# p view.print_board(game_model)
# game_model.new_board    == board_checker

# p "Return Tie --"
# p "---Enter 0,1,2,4,7,3,6,8,5"
# game_model.current_player.set_position!#(0)
# game_model.current_player.set_position!#(1) #other player
# game_model.current_player.set_position!#(2)
# game_model.current_player.set_position!#(4) #other player
# game_model.current_player.set_position!#(7) #other player
# game_model.current_player.set_position!#(3)
# game_model.current_player.set_position!#(6)
# game_model.current_player.set_position!#(8)
# game_model.current_player.set_position!#(5)
# p game_model.winner?        == false
# p game_model.tie?        == true

p "Check if board reset"
p view.print_board(game_model)
game_model.new_board
p view.print_board(game_model)

# Unable to move
# p "Player unable to move--until you enter an available number (not 0)"
# game_model.current_player.set_position!(0)
# game_model.current_player.set_position!(0)
# p view.print_board(game_model)

p "Lets play!"
my_game = TicTacToe::GameController.new
my_game.play
