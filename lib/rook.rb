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
    slide_vectors = [[1, 0], [-1, 0], [0, -1], [0, 1]]
    slide_vectors.each do |vector|
      update_valid_positions(vector[0], vector[1], board, valid_positions, myself)
    end
  end
  
  def update_valid_positions (row_mod, col_mod, board, valid_positions, myself)
    initial_position = myself.position # [row, column]
    own_color = myself.color
    row = initial_position[0] + row_mod
    col = initial_position[1] + col_mod
    while (0..7).include?(row) && (0..7).include?(col)
      next_square = board[row][col]
      p "Coords: #{row}, #{col}"
      if next_square.nil?
        # valid position, add to array and continue searching
        valid_positions << [row, col]
      elsif next_square.color != myself.color
        # valid position taken by opponent's piece, add to array and stop searching further
        valid_positions << [row, col]
        break
      end
      row += row_mod
      col += col_mod
    end
  end
end