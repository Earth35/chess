class Chess
  attr_reader :player_1, :player_2
  attr_accessor :board, :current_player
  
  def initialize
    @player_1 = Player.new(:white)
    @player_2 = Player.new(:black)
    @board = Board.new
    @current_player = @player_1
  end
end