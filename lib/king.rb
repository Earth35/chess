class King < Piece
  attr_reader :symbol
  def initialize (color, position)
    super(color, position)
  end
end