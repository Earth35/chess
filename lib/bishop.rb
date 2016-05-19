class Bishop < Piece
  attr_reader :symbol
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "B", "b")
  end
end