class Piece
  attr_reader :color
  attr_accessor :position
  def initialize (color, position)
    @color = color
    @position = position
  end
  
  private
  
  def self.set_symbol (color, white_ver, black_ver)
    symbol = case color
    when :white
      return white_ver
    when :black
      return black_ver
    end
  end
end