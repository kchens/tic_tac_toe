# used to play game in "rails console"

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
