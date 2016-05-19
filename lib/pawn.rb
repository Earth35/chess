class Pawn < Piece
  attr_reader :symbol
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "P", "p")
  end
end