class Bishop < Piece
  attr_reader :symbol, :slide_vectors
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "B", "b")
    @slide_vectors = [[-1, 1], [1, 1], [1, -1], [-1, -1]]
  end
  
  def movement_valid? (board, coordinates)
    myself = board[coordinates[0][1]][coordinates[0][0]]
    target_coordinates = [coordinates[1][1], coordinates[1][0]]
    valid_positions = []
    find_valid_positions(board, valid_positions)
    return valid_positions.include?(target_coordinates) ? true : false
  end
  
  def danger_zones (board)
    danger_zones = []
    find_valid_positions(board, danger_zones)
    return danger_zones
  end
  
  private
  
  def find_valid_positions (board, valid_positions)
    @slide_vectors.each do |vector|
      # seeks valid positions in specific direction
      update_valid_positions(vector[0], vector[1], board, valid_positions)
    end
  end
  
  def update_valid_positions (row_mod, col_mod, board, valid_positions)
    row = @position[0] + row_mod
    col = @position[1] + col_mod
    while (0..7).include?(row) && (0..7).include?(col)
      next_square = board[row][col]
      if next_square.nil?
        # valid position, add to array and continue searching
        valid_positions << [row, col]
      elsif next_square.color != @color
        # valid position taken by opponent's piece, add to array and stop searching further
        valid_positions << [row, col]
        break
      elsif next_square.color == @color
        break
      end
      row += row_mod
      col += col_mod
    end
  end
end
