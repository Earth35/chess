class Pawn < Piece
  attr_reader :symbol
  attr_accessor :first_move
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "P", "p")
    @first_move = true
  end
end