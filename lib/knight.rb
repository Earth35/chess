class Knight < Piece
  attr_reader :symbol
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "N", "n")
  end
  
  def movement_valid? (coordinates)
    valid_vectors = [
      [-2, -1], [-2, 1], [-1, -2], [-1, 2],
      [1, 2], [1, -2], [2, 1], [2, -1]
    ]
    vector = [coordinates[0][0] - coordinates[1][0], coordinates[0][1] - coordinates[1][1]]
    return valid_vectors.include?(vector) ? true : false
  end
end