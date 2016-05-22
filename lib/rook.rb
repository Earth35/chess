class Rook < Piece
  attr_reader :symbol
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "R", "r")
  end
  
  def movement_valid? (board, coordinates)
    myself = board[coordinates[0][1]][coordinates[0][0]]
    target_coordinates = [coordinates[1][1], coordinates[1][0]]
    valid_positions = []
    find_valid_positions(board, coordinates, myself, valid_positions)
    return valid_positions.include?(target_coordinates) ? true : false
  end
  
  private
  
  def find_valid_positions (board, coordinates, myself, valid_positions)
    initial_position = myself.position # [row, column]
    own_color = myself.color
    # slide forward
    row = initial_position[0] + 1
    col = initial_position[1]
    while row < 8
      stop = update_valid_positions(row, col, board, valid_positions, myself)
      break if stop
      row += 1
    end
    # slide backward
    row = initial_position[0] - 1
    col = initial_position[1]
    while row >= 0
      stop = update_valid_positions(row, col, board, valid_positions, myself)
      break if stop
      row -= 1
    end
    # slide left
    row = initial_position[0]
    col = initial_position[1] - 1
    while col >= 0
      stop = update_valid_positions(row, col, board, valid_positions, myself)
      break if stop
      col -= 1
    end
    # slide right
    row = initial_position[0]
    col = initial_position[1] + 1
    while col < 8
      stop = update_valid_positions(row, col, board, valid_positions, myself)
      break if stop
      col += 1
    end
  end
  
  def update_valid_positions (row, col, board, valid_positions, myself)
    next_square = board[row][col]
    if next_square.nil?
      # valid position, add to array and continue searching
      valid_positions << [row, col]
    elsif next_square.color != myself.color
      # valid position taken by opponent's piece, add to array and stop searching further
      valid_positions << [row, col]
      return true
    end
    return false
  end
end