class Knight < Piece
  attr_reader :symbol, :valid_vectors
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "N", "n")
    @valid_vectors = [
      [-2, -1], [-2, 1], [-1, -2], [-1, 2],
      [1, 2], [1, -2], [2, 1], [2, -1]
    ]
  end
  
  def movement_valid? (board, coordinates)
    vector = [coordinates[1][0] - coordinates[0][0], coordinates[1][1] - coordinates[0][1]]
    return @valid_vectors.include?(vector) ? true : false
  end
  
  def danger_zones (board)
    danger_zones = []
    @valid_vectors.each do |vector|
      new_row = @position[0] + vector[1]
      new_col = @position[1] + vector[0]
      if (0..7).include?(new_row) && (0..7).include?(new_col)
        potential_pos = [new_row, new_col]
        potential_danger_zone = board[potential_pos[0]][potential_pos[1]]
        if potential_danger_zone.nil?
          danger_zones << potential_pos
        elsif potential_danger_zone.color != @color
          danger_zones << potential_pos
        end
      end
    end
    return danger_zones
  end
end
