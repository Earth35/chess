class King < Piece
  attr_reader :symbol
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "K", "k")
  end
  
  def movement_valid? (board, coordinates)
    valid_vectors = [
      [0, 1], [1, 1], [1, 0], [1, -1],
      [0, -1], [-1, -1], [-1, 0], [-1, 1]
    ]
    vector = [coordinates[1][0] - coordinates[0][0], coordinates[1][1] - coordinates[0][1]]
    return valid_vectors.include?(vector) ? true : false
  end
end