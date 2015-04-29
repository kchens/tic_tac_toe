class Game
  # belongs_to :board
  attr_reader :human_player, :computer_player

  def initialize(board_factory, human_player_factory, computer_player_factory)
    @board = board_factory.new

    @human_player = human_player_factory.new("X")
    @computer_player = computer_player_factory.new("O")

    @players = [human_player, computer_player]
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

  def play(start_human = "true")
    unless start_human == "true"
      switch_players!
    end
    # VIEW.print_board(board)
    # VIEW.print_players_turn(current_player.marker)
    until board.game_over?
      @board = current_player.move(board)
      # VIEW.print_board(board)
      if board.winner?
        # return VIEW.print_winner(board.winner)
      elsif board.tie?
        # return VIEW.print_tie
      else
        switch_players!
        return create_json_response
        # VIEW.print_players_turn(current_player.marker)
      end
    end
  end

  def switch_players!
    @current_player_id = (@current_player_id == 0) ? 1 : 0
  end

  def create_json_response
    {
      winner: board.winner,
      players:
      {
        human_player: human_player.marker,
        computer_player: computer_player.marker
      },
      board: board
    }
  end

end
