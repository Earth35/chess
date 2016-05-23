class Player
  attr_reader :color
  attr_accessor :king
  def initialize (color)
    @color = color
    @king = nil
  end
end
