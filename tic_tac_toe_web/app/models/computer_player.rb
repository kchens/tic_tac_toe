class ComputerPlayer < Player

  def move(game_board, chosen_index = nil)
    return game_board.place_piece([0,2,6,8].sample, marker) if game_board.empty?
    minmax(game_board) #minmax to create @best_move
    game_board.place_piece(@best_move, marker)
  end

  def minmax(board, player_tracker = 0, game_depth = 1) #minmax
    return score(board, game_depth) if board.game_over?

    new_marker = player_tracker.even? ? 'O' : 'X'

    scores = {}
    board.get_available_positions.each do |move|
      new_board = board.place_piece(move, new_marker)
      scores[move] = minmax(new_board, player_tracker + 1, game_depth + 1)
    end

    if player_tracker.even?
      @best_move = scores.max_by {|_key, value| value}[0]
    else
      @best_move = scores.min_by {|_key, value| value}[0]
    end

    return scores[@best_move]
  end

  def score(board, game_depth)
    if board.winning_piece?("O")
      10 - game_depth
    elsif board.winning_piece?("X")
      -10 - game_depth
    elsif board.winning_piece?(nil)
      0
    else
      raise "ERROR"
    end
  end
end
