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

    @board = current_player.move(board)

    return json_response if board.game_over?
    return json_response if board.winner?
    return json_response if board.tie?

    switch_players!
    set_json_response(start_human)
    return json_response
  end

  def switch_players!
    @current_player_id = (@current_player_id == 0) ? 1 : 0
  end


  def set_json_response(start_human)
    @json_response = {
      startHuman: start_human,
      winner: board.winner,
      tie: board.tie?,
      players:
      {
        humanPlayer: human_player.marker,
        computerPlayer: computer_player.marker
      },
      board: board
    }
  end

  attr_reader :json_response

end
