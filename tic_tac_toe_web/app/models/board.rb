class Board #< ActiveRecord::Base
  # has_one :game

  attr_reader :positions

def initialize(positions = nil)
    @positions = positions || Array.new(9) {|num| num }
  end

  def full?
    positions.all? {|position| position.is_a?(String) }
  end

  def empty?
    positions.all? {|position| position.is_a?(Integer) }
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
    winner? || tie?
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
    (full? && !@winner) ? true : false
  end

  def winning_piece?(marker)
    @winner == marker
  end
end
