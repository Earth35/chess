class Chess
  attr_reader :player_1, :player_2
  attr_accessor :board, :current_player
  
  def initialize
    @player_1 = Player.new(:white)
    @player_2 = Player.new(:black)
    @board = Board.new
    @current_player = @player_1
  end
  
  private
  
  # converts strings to arrays of coordinates, e.g. "a1" and "a2" => [[0, 0], [0, 1]]
  # arguments must be validated and properly formatted beforehand
  def input_to_coords (source, target)
    coord_map = {
      'a' => 0, '1' => 0,
      'b' => 1, '2' => 1,
      'c' => 2, '3' => 2,
      'd' => 3, '4' => 3,
      'e' => 4, '5' => 4,
      'f' => 5, '6' => 5,
      'g' => 6, '7' => 6,
      'h' => 7, '8' => 7
    }
    source_in = source.split(//)
    source_out = [coord_map[source_in[0]], coord_map[source_in[1]]]
    target_in = target.split(//)
    target_out = [coord_map[target_in[0]], coord_map[target_in[1]]]
    return[source_out, target_out]
  end
end